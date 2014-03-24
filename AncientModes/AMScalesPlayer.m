//
//  AMScalesPlayer.m
//  AncientModes
//
//  Created by Vladimir Mollov on 1/18/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScalesPlayer.h"
#import "AMDataManager.h"

@interface AMScalesPlayer()
@property MusicPlayer player;

@property AUGraph processingGraph;
@property double graphSampleRate;
@property AudioUnit samplerUnit;
@property AudioUnit ioUnit;

@property MusicTrack tempoTrack;
@property MusicTimeStamp playEndMark;
@end

@implementation AMScalesPlayer

#pragma mark - Object Management
+(id)getInstance{
    static AMScalesPlayer *sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayer = [[self alloc] init];
    });
    
    return sharedPlayer;
}
-(id)init{
    if(self = [super init]){
        if(![self setup]) return nil;
    }
    
    return self;
}

-(BOOL)setup{
    //initialize the player
    NewMusicPlayer(&_player);
    
    //setup the audio session and the AUGraph
    if (![self setupAudioSession]) { NSLog(@"Could not set up audio session"); return false;}
    if(![self createAUGraph]) { NSLog(@"Could not create AUGraph"); return false; }
    [self configureAndStartAudioProcessingGraph:self.processingGraph];
    
    //Load the default player settings
    NSString *defaultSample = [[NSUserDefaults standardUserDefaults] objectForKey:@"playSample"];
    [self loadSample:defaultSample]; //also sets _currentSample
    Float64 defaultTempo = [[NSUserDefaults standardUserDefaults] floatForKey:@"playTempo"];
    [self changeTempoTo:defaultTempo]; //also sets _tempo

    return true;
}
-(BOOL)takeDown{
    DisposeMusicPlayer(_player);
    DisposeAUGraph(_processingGraph);
    AudioUnitUninitialize(_samplerUnit);
    AudioUnitUninitialize(_ioUnit);
    
    return true;
}

#pragma mark - Samples Control Methods
-(void)loadPianoSample{
    if(![self.currentSample isEqualToString:@"Piano"]){
        [self loadSample:@"Piano"];
    }
}
-(void)loadTromboneSample{
    if(![self.currentSample isEqualToString:@"Trombone"]){
        [self loadSample:@"Trombone"];
    }
}
-(void)loadVibraphoneSample{
    if(![self.currentSample isEqualToString:@"Vibraphone"]){
        [self loadSample:@"Vibraphone"];
    }
}

#pragma mark - Player Controls and Status
-(void)playScale:(AMScale *) scale{
    BOOL playAsc = [[NSUserDefaults standardUserDefaults] boolForKey:@"playAscending"];
    BOOL playDesc = [[NSUserDefaults standardUserDefaults] boolForKey:@"playDescending"];
    MusicSequence scaleSequence;
    if(playAsc) scaleSequence = [scale scaleSequenceAsc];
    if(playDesc) scaleSequence = [scale scaleSequenceDesc];
    if(playAsc && playDesc) scaleSequence =[scale scaleSequence];
        
    [self playSequence:scaleSequence];
}

-(void)playSequence:(MusicSequence)sequence{
    //stop player if it is currently playing
    if ([self isPlaying]) [self stop];
    
    //set the graph to the sequence
    MusicSequenceSetAUGraph(sequence, self.processingGraph);
    // Load the sequence into the music player
    MusicPlayerSetSequence(_player, sequence);
    
    //get the tempo track and set the tempo
    MusicSequenceGetTempoTrack(sequence, &_tempoTrack);
    [self changeTempoTo:self.tempo];
    
    //prepare playback
    MusicPlayerPreroll(_player);
    //start playback
    MusicPlayerStart(_player);
    self.playEndMark = [self getLoadedSequenceLength];
    
    [self autoStopAtSequenceEnd];
}

-(void)stop{
    MusicPlayerStop(_player);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScalesPlayerStoppedPlayback" object:self];
}
-(void)changeTempoTo:(Float64)newTempo{
    //change the tempo in the tempo track
    if(_tempoTrack != nil) MusicTrackNewExtendedTempoEvent(_tempoTrack, 0.0, newTempo);
    [self setTempo:newTempo];
    [[NSUserDefaults standardUserDefaults] setFloat:newTempo forKey:@"playTempo"];
    self.playEndMark = [self getLoadedSequenceLength];
}
-(BOOL)isPlaying{
    Boolean isPlaying;
    MusicPlayerIsPlaying(_player, &isPlaying);
    return isPlaying;
}

#pragma mark - Private Utility Methods
-(void)autoStopAtSequenceEnd{
    if([self getPlayerTimeInBeats] > self.playEndMark) [self stop];
    else [self performSelector:@selector(autoStopAtSequenceEnd)  withObject:self afterDelay:1.0];
}
-(Float64)getPlayerTimeInBeats{
    Float64 currentTime;
    MusicPlayerGetTime(_player, &currentTime);
    return currentTime;
}
-(MusicTimeStamp)getLoadedSequenceLength{
    MusicSequence theSequence;
    MusicPlayerGetSequence(_player, &theSequence);

    //get the sequence time lenght
    UInt32 tracks;
    MusicTimeStamp sequenceLength = 0.0f;
    
    if (MusicSequenceGetTrackCount(theSequence, &tracks) != noErr || theSequence == nil) return sequenceLength;
    
    for (UInt32 i = 0; i < tracks; i++) {
        MusicTrack track = NULL;
        MusicTimeStamp trackLen = 0;
        UInt32 trackLenSize = sizeof(trackLen);
        
        MusicSequenceGetIndTrack(theSequence, i, &track);
        MusicTrackGetProperty(track, kSequenceTrackProperty_TrackLength, &trackLen, &trackLenSize);
        
        if (sequenceLength < trackLen) sequenceLength = trackLen;
    }
    return sequenceLength;
}

#pragma mark - Audio Configuration Methods
-(void)AudioInterruption:(NSNotification *) notification{
    NSNumber *interruptionType = [[notification userInfo] objectForKey:@"AVAudioSessionInterruptionTypeKey"];
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:
            [self stop];
            break;
            
        case AVAudioSessionInterruptionTypeEnded:
            [self setup];
            break;
        default:
            break;
    }
}

-(BOOL)setupAudioSession{
    AVAudioSession *playerAudioSession = [AVAudioSession sharedInstance];
   
    //Handle Interruptions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AudioInterruption:) name:AVAudioSessionInterruptionNotification object:playerAudioSession];

    //Assign the Playback category to the audio session. This category supports audio output with the Ring/Silent switch in the Silent position.
    NSError *audioSessionError = nil;
    [playerAudioSession setCategory: AVAudioSessionCategoryPlayback error: &audioSessionError];
    if (audioSessionError != nil) {
        NSLog (@"Error setting audio session category."); return NO;}
    
    //Request a desired hardware sample rate.
    self.graphSampleRate = 44100.0;    // Hertz
    [playerAudioSession setPreferredSampleRate: self.graphSampleRate error: &audioSessionError];
    if (audioSessionError != nil) {NSLog (@"Error setting preferred hardware sample rate."); return NO;}
    
    //Activate the audio session
    [playerAudioSession setActive: YES error: &audioSessionError];
    if (audioSessionError != nil) {NSLog (@"Error activating the audio session."); return NO;}
    
    //Obtain the actual hardware sample rate and store it for later use in the audio processing graph.
    self.graphSampleRate = [playerAudioSession sampleRate];
    
    return YES;
}

-(BOOL)createAUGraph{
    OSStatus result = noErr;
	AUNode samplerNode, ioNode;
    
    //Specify the common portion of an audio unit's identify, used for both audio units in the graph.
	AudioComponentDescription cd = {};
	cd.componentManufacturer     = kAudioUnitManufacturer_Apple;
	cd.componentFlags            = 0;
	cd.componentFlagsMask        = 0;
    
    //Instantiate an audio processing graph
	result = NewAUGraph (&_processingGraph);
    NSCAssert (result == noErr, @"Unable to create an AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	//Specify the Sampler unit, to be used as the first node of the graph
	cd.componentType = kAudioUnitType_MusicDevice;
	cd.componentSubType = kAudioUnitSubType_Sampler;
	
    //Add the Sampler unit node to the graph
	result = AUGraphAddNode (self.processingGraph, &cd, &samplerNode);
    NSCAssert (result == noErr, @"Unable to add the Sampler unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	//Specify the Output unit, to be used as the second and final node of the graph
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_RemoteIO;
    
    //Add the Output unit node to the graph
	result = AUGraphAddNode (self.processingGraph, &cd, &ioNode);
    NSCAssert (result == noErr, @"Unable to add the Output unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    //Open the graph
	result = AUGraphOpen (self.processingGraph);
    NSCAssert (result == noErr, @"Unable to open the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    // Connect the Sampler unit to the output unit
	result = AUGraphConnectNodeInput (self.processingGraph, samplerNode, 0, ioNode, 0);
    NSCAssert (result == noErr, @"Unable to interconnect the nodes in the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	//Obtain a reference to the Sampler unit from its node
	result = AUGraphNodeInfo (self.processingGraph, samplerNode, 0, &_samplerUnit);
    NSCAssert (result == noErr, @"Unable to obtain a reference to the Sampler unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
	//Obtain a reference to the I/O unit from its node
	result = AUGraphNodeInfo (self.processingGraph, ioNode, 0, &_ioUnit);
    NSCAssert (result == noErr, @"Unable to obtain a reference to the I/O unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    return YES;
}

- (void) configureAndStartAudioProcessingGraph: (AUGraph) graph {
    OSStatus result = noErr;
    UInt32 framesPerSlice = 0;
    UInt32 framesPerSlicePropertySize = sizeof (framesPerSlice);
    UInt32 sampleRatePropertySize = sizeof (self.graphSampleRate);
    
    result = AudioUnitInitialize (self.ioUnit);
    NSCAssert (result == noErr, @"Unable to initialize the I/O unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    //Set the I/O unit's output sample rate.
    result = AudioUnitSetProperty (self.ioUnit, kAudioUnitProperty_SampleRate, kAudioUnitScope_Output, 0, &_graphSampleRate, sampleRatePropertySize);
    NSAssert (result == noErr, @"AudioUnitSetProperty (set Sampler unit output stream sample rate). Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    //Obtain the value of the maximum-frames-per-slice from the I/O unit.
    result = AudioUnitGetProperty (self.ioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &framesPerSlice, &framesPerSlicePropertySize);
    NSCAssert (result == noErr, @"Unable to retrieve the maximum frames per slice property from the I/O unit. Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    //Set the Sampler unit's output sample rate.
    result = AudioUnitSetProperty (self.samplerUnit, kAudioUnitProperty_SampleRate, kAudioUnitScope_Output, 0, &_graphSampleRate, sampleRatePropertySize);
    NSAssert (result == noErr, @"AudioUnitSetProperty (set Sampler unit output stream sample rate). Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    //Set the Sampler unit's maximum frames-per-slice.
    result = AudioUnitSetProperty (self.samplerUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &framesPerSlice, framesPerSlicePropertySize);
    NSAssert( result == noErr, @"AudioUnitSetProperty (set Sampler unit maximum frames per slice). Error code: %d '%.4s'", (int) result, (const char *)&result);
    
    if (graph) {
        //Initialize the audio processing graph.
        result = AUGraphInitialize (graph);
        NSAssert (result == noErr, @"Unable to initialze AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
        
        //Start the graph
        result = AUGraphStart (graph);
        NSAssert (result == noErr, @"Unable to start audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
        
        //Print out the graph to the console
        //CAShow (graph); //Requires import of AudioToolbox.h
    }
}

-(void)loadSample:(NSString *) samplePreset{
    NSURL *presetURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:samplePreset ofType:@"aupreset"]];
    if (!presetURL) {
        NSLog(@"COULD NOT GET PRESET PATH FOR %@!", samplePreset);
        return;
    }
    
    CFDataRef propertyResourceData = 0;
	Boolean status;
	SInt32 errorCode;
    errorCode = 0;
	//OSStatus result = noErr;
	
    NSError *errorCode2;
    //get the property data in an NSData object
    NSData *propertyData = [NSData dataWithContentsOfURL:presetURL options:0 error:&errorCode2];
    //convert it to CFDataRef
    propertyResourceData = CFDataCreate(NULL, [propertyData bytes], [propertyData length]);
    status = nil != propertyData;
    NSAssert (status == YES && propertyResourceData != 0, @"Unable to create data and properties from a preset. Error code: %d '%.4s'", (int) errorCode, (const char *)&errorCode);
   	
	// Convert the data object into a property list
	CFPropertyListRef presetPropertyList = 0;
	CFPropertyListFormat dataFormat = 0;
	CFErrorRef errorRef = 0;
	presetPropertyList = CFPropertyListCreateWithData (kCFAllocatorDefault, propertyResourceData, kCFPropertyListImmutable, &dataFormat, &errorRef);
    
    // Set the class info property for the Sampler unit using the property list as the value.
	if (presetPropertyList != 0) {
		//result =
        AudioUnitSetProperty(self.samplerUnit, kAudioUnitProperty_ClassInfo, kAudioUnitScope_Global, 0, &presetPropertyList, sizeof(CFPropertyListRef));
		CFRelease(presetPropertyList);
	}
    
    if (errorRef) CFRelease(errorRef);
	CFRelease (propertyResourceData);
    
    _currentSample = samplePreset;
    [[NSUserDefaults standardUserDefaults] setObject:samplePreset forKey:@"playSample"];
    
    NSLog(@"%@ sample loaded succesfully!", samplePreset);
}

@end

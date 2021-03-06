//
//  AMTestViewController.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMTestVC.h"
#import "AMScalesPlayer.h"
#import "AMDataManager.h"
#import "AMEndTestVC.h"
#import "UIViewController+Parallax.h"
#import <iAd/iAd.h>

@interface AMTestVC ()
@property NSArray *answerButtons;
@property AMEarTest *currentTest;
@end

@implementation AMTestVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setParallaxToView:self.imgBackground];
    
    //prepare the controls
    BOOL testOutOf8 = [[NSUserDefaults standardUserDefaults] boolForKey:@"testOutOf8Answers"];
    self.lbScore.text = @"";
    self.answerButtons = testOutOf8? @[self.btnAnswer1, self.btnAnswer2, self.btnAnswer3, self.btnAnswer4, self.btnAnswer5, self.btnAnswer6, self.btnAnswer7, self.btnAnswer8] : @[self.btnAnswer1, self.btnAnswer2, self.btnAnswer3, self.btnAnswer4];
    
    for(UIButton * aButton in self.answerButtons){
        [aButton setTitle:@"" forState:UIControlStateNormal];
        aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        if(!testOutOf8){
            CGRect frame = aButton.frame;
            frame.size.width = 319;
            aButton.frame = frame;
        }
    }
    
    self.slTempo.value = [[AMScalesPlayer getInstance] tempo];
    self.lbTempo.text = [NSString stringWithFormat:@"%.f", self.slTempo.value];
    
    self.switchAutoAdvance.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoAdvance"];
    
    //initiate a new test
    int numberOfPresentedAnswers = testOutOf8?8:4;
    int numberOfChallenges = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfQuestions"];
    BOOL sameStartNote = [[NSUserDefaults standardUserDefaults] boolForKey:@"ChallengeOnSameNote"];
    self.currentTest = sameStartNote?[[AMEarTest alloc] initWithNumberOfChallenges:numberOfChallenges startingNote:@"C4" numberOfPresentedAnswers:numberOfPresentedAnswers]:[[AMEarTest alloc]initWithNumberOfChallenges:numberOfChallenges numberOfPresentedAnswers:numberOfPresentedAnswers];
    
    [self presentChallenge];
}
//this method will make the status bar content colored white
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //remove the navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //setup the plyer stopp event observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoppedPlayback) name:@"ScalesPlayerStoppedPlayback" object:nil];
    
    //setup audio interruption observer
    //Handle Interruptions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoppedPlayback) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //add back the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[AMScalesPlayer getInstance]stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScalesPlayerStoppedPlayback" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionInterruptionNotification" object:[AVAudioSession sharedInstance]];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handlers
- (IBAction)changeTempo:(id)sender {
    [[AMScalesPlayer getInstance] changeTempoTo:self.slTempo.value];
    self.lbTempo.text = [NSString stringWithFormat:@"%.f", _slTempo.value];
}

- (IBAction)nextChallenge:(id)sender {
    //update the persistent stats
    if(!self.currentTest.getCurrentChallenge.answered) [self selectAnswer:nil];
    
    [self advanceTest];
}
- (IBAction)playAgain:(id)sender {
    [self playCurrentScale];
}
- (IBAction)selectAnswer:(id)sender {
    if(self.currentTest.getCurrentChallenge.answered) return;
    
    UIButton *currentSelection = sender;
    for(UIButton *answerButton in self.answerButtons){
        if(currentSelection != answerButton) {
            answerButton.selected = NO;
        }
        currentSelection.selected = YES;
    }
    
    self.hintView.hidden = YES;
    
    //determine if selected answer is correct
    BOOL correct;
    if((correct = [_currentTest checkAnswer:currentSelection.titleLabel.text])){
        self.lbCorrect.text = @"Correct!";
        self.lbCorrect.textColor = [UIColor greenColor];
        self.lbCorrect.hidden = NO;
        self.btnHint.enabled = YES;
    }else{
        self.lbCorrect.text = @"Incorrect!";
        self.lbCorrect.textColor = [UIColor redColor];
        self.lbCorrect.hidden = NO;
        
        //highlight the correct answer
        UIButton *correctAnswer = [self.answerButtons objectAtIndex:self.currentTest.getCurrentChallenge.correctAnswerIndex];
        correctAnswer.highlighted = YES;
        UIColor *highlightColor = [correctAnswer titleColorForState:UIControlStateHighlighted];
        [correctAnswer setTitleColor:highlightColor forState:UIControlStateNormal];
    }
    
    //update the persistent stats
    [[AMDataManager getInstance] updateStatisticsForMode:_currentTest.getCurrentChallenge.scale.mode.name correct:correct neededHint:self.currentTest.getCurrentChallenge.usedHint testTimeStamp:_currentTest.timeStamp];
    
    //update the running score
    NSNumberFormatter *floatFormatter = [[NSNumberFormatter alloc]init];
    [floatFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [floatFormatter setMaximumFractionDigits:1];
    self.lbScore.text=[NSString stringWithFormat:@"%@%%", [floatFormatter stringFromNumber:[NSNumber numberWithFloat:_currentTest.getRunningScore]]];
    
    if(sender != nil && [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoAdvance"]) [self performSelector:@selector(advanceTest) withObject:nil afterDelay:1];
}

- (IBAction)showHint:(id)sender {
    NSMutableArray *scaleNotePaths = [[NSMutableArray alloc]initWithCapacity:8];
    [scaleNotePaths addObject:@"noteImages/trblClef"];
    for (NSString *scale in _currentTest.getHint){
        [scaleNotePaths addObject:[@"noteImages" stringByAppendingPathComponent:scale]];
    }
    
    self.hintView.noteImages = scaleNotePaths;
    self.hintView.spacer = @"noteImages/staff";
    [self.hintView refresh];
    self.lbCorrect.hidden = YES;
    self.hintView.hidden = NO;
    self.btnHint.enabled = NO;
}

- (IBAction)changeAutoAdvance:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.switchAutoAdvance.on forKey:@"AutoAdvance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.switchAutoAdvance.on) {
        if(self.currentTest.getCurrentChallenge.answered) [self nextChallenge:nil];
    }
}

#pragma mark
#pragma mark Private Methods
-(void)advanceTest{
    
    if(!self.currentTest.hasNextChallenge) {
        [self performSegueWithIdentifier:@"exitTestSegue" sender:nil];
        return;
    }
    
    //adjust the labels
    for(int i=0; i<[self.answerButtons count]; i++){
        UIButton *answerButton = [self.answerButtons objectAtIndex:i];
        answerButton.selected = false;
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }

    [self.currentTest getNextChallenge];
    [self presentChallenge];
}
-(void) presentChallenge{
    AMTestChallenge *currentChallenge = [self.currentTest getCurrentChallenge];
    for(int i = 0; i<[self.answerButtons count]; i++){
        UIButton *answerButton = [self.answerButtons objectAtIndex:i];
        [answerButton setTitle:[currentChallenge.presentedAnswers objectAtIndex:i] forState:UIControlStateNormal];
        answerButton.selected = answerButton.highlighted = NO;
    }
    
    //adjust the labels and question navigation buttons
    self.lbProgress.text = [NSString stringWithFormat:@"Question %i of %lu", self.currentTest.challengeIndex + 1, (unsigned long)[self.currentTest.challenges count]];
    
    //hide the hint and correct indicator
    [self.hintView clear];
    self.hintView.hidden=YES;
    self.btnHint.enabled=YES;
    self.lbCorrect.hidden=YES;
    
    [self playCurrentScale];
}
-(void)playCurrentScale{
    [[AMScalesPlayer getInstance] playScale:self.currentTest.getCurrentChallenge.scale];
    self.btnPlayAgain.enabled = self.btnPlayAgainImg.enabled = false;
}

#pragma mark - ScalesPlayerDelegate Methods
-(void)playerStoppedPlayback{
    self.btnPlayAgain.enabled = self.btnPlayAgainImg.enabled = true;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"exitTestSegue"]){
        [[AMScalesPlayer getInstance] stop];
        AMEndTestVC *destination = [segue destinationViewController];
        destination.test = self.currentTest;
        destination.questions = (int)self.currentTest.challengeIndex;
        if(self.currentTest.getCurrentChallenge.answered) destination.questions++;
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"enableAdvancedModes"]) destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;

    }
}
@end

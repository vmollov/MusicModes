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

@interface AMTestVC ()
@property NSArray *answerButtons;
@property AMEarTest *currentTest;
@end

@implementation AMTestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //prepare the controls
    _lbPlayIndicator.text = @"";
    _lbScore.text = @"";
    _answerButtons = @[_btnAnswer1, _btnAnswer2, _btnAnswer3, _btnAnswer4];
    for(int i = 0; i<[_answerButtons count]; i++){
        [[_answerButtons objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
    }
    _slTempo.value = [[AMScalesPlayer getInstance] tempo];
    _lbTempo.text = [NSString stringWithFormat:@"%.f", _slTempo.value];
    
    //initiate a new test
    _currentTest = [[AMEarTest alloc]initWithNumberOfChallenges:10];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStoppedPlayback) name:@"ScalesPlayerStoppedPlayback" object:nil];
    
    [self presentChallenge];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTempo:(id)sender {
    [[AMScalesPlayer getInstance] changeTempoTo:_slTempo.value];
    _lbTempo.text = [NSString stringWithFormat:@"%.f", _slTempo.value];
}

- (IBAction)previousChallenge:(id)sender {
    [_currentTest getPreviousChallenge];
    [self presentChallenge];
}

- (IBAction)nextChallenge:(id)sender {
    [_currentTest getNextChallenge];
    [self presentChallenge];
}

- (IBAction)playAgain:(id)sender {
    [self playCurrentScale];
}

- (IBAction)selectAnswer:(id)sender {
    UIButton *currentSelection = sender;
    for(int i=0; i<[_answerButtons count]; i++){
        UIButton *item = [_answerButtons objectAtIndex:i];
        if(currentSelection != item) {
            item.selected = false;
        }
        currentSelection.selected = true;
    }
    
    //determine if selected answer is correct
    BOOL correct = [_currentTest checkAnswer:currentSelection.titleLabel.text];
    if(correct) _lbPlayIndicator.text = @"Correct!";
    else _lbPlayIndicator.text = @"Wrong!";
    
    //update the persistent stats
    [[AMDataManager getInstance] updateStatisticsForMode:_currentTest.getCurrentChallenge.scale.mode.name neededHint:NO testTimeStamp:_currentTest.timeStamp];
    
    _lbScore.text=[NSString stringWithFormat:@"%i correct!", _currentTest.correctAnswersCount];
    
    if(!_currentTest.hasNextChallenge) [self finalizeTest];
}

- (IBAction)showHint:(id)sender {
    NSMutableArray *scaleNotePaths = [[NSMutableArray alloc]initWithCapacity:8];
    [scaleNotePaths addObject:@"Images/Notes/trblClef"];
    for (NSString *scale in _currentTest.getCurrentChallenge.scale.getNotes){
        [scaleNotePaths addObject:[@"Images/Notes" stringByAppendingPathComponent:scale]];
    }
    
    self.hintView.noteImages = scaleNotePaths;
    [self.hintView refresh];
}

#pragma mark
#pragma mark Private Methods
-(void) presentChallenge{
    AMTestChallenge *currentChallenge = [_currentTest getCurrentChallenge];
    for(int i = 0; i<[_answerButtons count]; i++){
        [[_answerButtons objectAtIndex:i] setTitle:[currentChallenge.presentedAnswers objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    //adjust the labels and question navigation buttons
    self.navigationItem.title = [NSString stringWithFormat:@"Question %i of %lu", _currentTest.challengeIndex + 1, (unsigned long)[_currentTest.challenges count]];
    
    //hide the hint
    [self.hintView clear];
    
    [self playCurrentScale];
}
-(void)playCurrentScale{
    //adjust the labels
    _btnPlayAgain.enabled = _btnNext.enabled = _btnPrevious.enabled = false;
    _lbPlayIndicator.text = @"Playing...";
    for(int i=0; i<[_answerButtons count]; i++){
        UIButton *answerButton = [_answerButtons objectAtIndex:i];
        answerButton.selected = false;
    }
    
    [[AMScalesPlayer getInstance] playScale:_currentTest.getCurrentChallenge.scale];
}

-(void)finalizeTest{
    //adjust the controls
    for(int i = 0; i<[_answerButtons count]; i++){
        [[_answerButtons objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
    }

    _lbScore.text = [NSString stringWithFormat:@"Your Score is %.f%%", [_currentTest getFinalTestScorePercentage]];
    
}

#pragma mark
#pragma mark ScalesPlayerDelegate Methods
-(void)playerStoppedPlayback{
    _btnPlayAgain.enabled = true;
    _lbPlayIndicator.text = @"";
    
    _btnPrevious.enabled = (_currentTest.hasPreviousChallenge);
    _btnNext.enabled = (_currentTest.hasNextChallenge);
}
@end

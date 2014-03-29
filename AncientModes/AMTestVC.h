//
//  AMTestViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMEarTest.h"
#import "AMVisualExampleV.h"

@interface AMTestVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UILabel *lbTempo;
@property (strong, nonatomic) IBOutlet UILabel *lbCorrect;
@property (strong, nonatomic) IBOutlet UILabel *lbProgress;
@property (strong, nonatomic) IBOutlet UILabel *lbScore;
@property (strong, nonatomic) IBOutlet UISlider *slTempo;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayAgain;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayAgainImg;
@property (strong, nonatomic) IBOutlet UIButton *btnAnswer1;
@property (strong, nonatomic) IBOutlet UIButton *btnAnswer2;
@property (strong, nonatomic) IBOutlet UIButton *btnAnswer3;
@property (strong, nonatomic) IBOutlet UIButton *btnAnswer4;
@property (strong, nonatomic) IBOutlet UIButton *btnHint;
@property (strong, nonatomic) IBOutlet AMVisualExampleV *hintView;
@property (strong, nonatomic) IBOutlet UISwitch *switchAutoAdvance;

- (IBAction)changeTempo:(id)sender;
- (IBAction)nextChallenge:(id)sender;
- (IBAction)playAgain:(id)sender;
- (IBAction)selectAnswer:(id)sender;
- (IBAction)showHint:(id)sender;
- (IBAction)changeAutoAdvance:(id)sender;
@end

//
//  AMViewController.h
//  AncientModes
//
//  Created by Vladimir Mollov on 1/15/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMEarTest.h"
#import "AMScalesPlayer.h"

@interface AMViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtScale;
@property (strong, nonatomic) AMScalesPlayer *thePlayer;
@property AMEarTest *test;
@property (strong, nonatomic) IBOutlet UILabel *lbTempo;
@property (strong, nonatomic) IBOutlet UISlider *slTempo;
@property (strong, nonatomic) IBOutlet UILabel *lbPlaying;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)playScale:(id)sender;
- (IBAction)stopPlayer:(id)sender;
- (IBAction)playWithVibraphone:(id)sender;
- (IBAction)playWithTrombone:(id)sender;
- (IBAction)tempoChange:(id)sender;
- (IBAction)checkPlaying:(id)sender;
- (IBAction)previousChallenge:(id)sender;
- (IBAction)nextChallenge:(id)sender;
@end

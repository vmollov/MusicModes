//
//  AMModeDetailVC.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMScale.h"
#import "AMVisualExampleV.h"

@interface AMModeDetailVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtListenFor;
@property (strong, nonatomic) IBOutlet AMVisualExampleV *vwExample;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayExample;

@property NSString *modeName;
@property AMScale *scale;

- (IBAction)playExample:(id)sender;
@end

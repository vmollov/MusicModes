//
//  AMHintView.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMHintView : UIView
@property NSArray *noteImages;

-(void) refresh;
-(void)clear;

@end

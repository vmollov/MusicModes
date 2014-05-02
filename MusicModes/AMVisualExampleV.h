//
//  AMHintView.h
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVisualExampleV : UIView
@property NSArray *noteImages;
@property NSString *spacer;

-(void) refresh;
-(void)clear;

-(void)highlightNoteAtIndex:(NSInteger) index;
-(void)removeHighlights;
@end

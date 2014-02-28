//
//  AMCustomNavBar.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/27/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMCustomNavBar.h"

@implementation AMCustomNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.translucent = YES; //if set to no, the navigation bar will be black.
	
	const float colorMask[6] = {0, 255, 0, 255, 0, 255}; //customize your colorMask
	UIImage *img = [[UIImage alloc] init];
	UIImage *maskedImage = [UIImage imageWithCGImage:CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
	
	[self setBackgroundImage:maskedImage forBarMetrics:UIBarMetricsDefault];
}


@end

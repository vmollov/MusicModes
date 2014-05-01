//
//  UIViewController+Parallax.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 3/28/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "UIViewController+Parallax.h"

@implementation UIViewController (Parallax)
-(void)setParallaxToView:(UIView *)theView{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(30);
    verticalMotionEffect.maximumRelativeValue = @(-30);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(30);
    horizontalMotionEffect.maximumRelativeValue = @(-30);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [theView addMotionEffect:group];
}
@end

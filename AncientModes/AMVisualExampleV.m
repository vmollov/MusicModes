//
//  AMHintView.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMVisualExampleV.h"

@implementation AMVisualExampleV
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    
    return self;
}
-(void) refresh{
    [self clear];
    int noteStartx = 0;
    float subFrameWidth;
    
    //add the notes subviews
    for(NSString *note in self.noteImages){
        UIImage *noteImage = [UIImage imageNamed:note];
        float imageRatio = (float)noteImage.size.height/(float)noteImage.size.width;
        subFrameWidth = (float)self.frame.size.height/(float)imageRatio;
        
        UIImageView *noteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noteStartx,0, (int)subFrameWidth, self.frame.size.height)];
        noteImageView.image = noteImage;
        [self addSubview:noteImageView];
        
        noteStartx += subFrameWidth;
    }
    
    //fill the remaining space with the spacer
    while(noteStartx < self.frame.size.width){
        UIImage *spacerImage = [UIImage imageNamed:self.spacer];
        float imageRatio = (float)spacerImage.size.height/(float)spacerImage.size.width;
        subFrameWidth = (float)self.frame.size.height/(float)imageRatio;
        
        UIImageView *spacerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noteStartx, 0, (int)subFrameWidth, self.frame.size.height)];
        spacerImageView.image = spacerImage;
        [self addSubview:spacerImageView];
        
        noteStartx += subFrameWidth;
    }
}
-(void)clear{
    for(UIView *subview in self.subviews) [subview removeFromSuperview];
}

@end

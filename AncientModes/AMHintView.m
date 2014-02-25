//
//  AMHintView.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMHintView.h"

@implementation AMHintView
-(void) refresh{
    [self clear];
    
    //add the new subviews
    int noteStartx = 0;
    int noteWidth = (self.frame.size.width / self.noteImages.count);
    
    for(NSString *note in self.noteImages){
        UIImageView *noteImage = [[UIImageView alloc] initWithFrame:CGRectMake(noteStartx,0, noteWidth, self.frame.size.height)];
        noteImage.image = [UIImage imageNamed:note];
        [self addSubview:noteImage];
        
        noteStartx += noteWidth;
    }
}
-(void)clear{
    for(UIView *subview in self.subviews) [subview removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

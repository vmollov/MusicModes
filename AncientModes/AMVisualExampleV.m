//
//  AMHintView.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/24/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMVisualExampleV.h"

@interface AMVisualExampleV ()
@property NSMutableArray *imageViewCollection;
@property UIView *noteHighlightOverlay;
@end

@implementation AMVisualExampleV
-(void) refresh{
    [self clear];
    int noteStartx = 0;
    float subFrameWidth;
    
    //add the notes subviews
    for(int index = 0; index<self.noteImages.count; index++){
        NSString *note = [self.noteImages objectAtIndex:index];
        
        UIImage *noteImage = [UIImage imageNamed:note];
        float imageRatio = (float)noteImage.size.height/(float)noteImage.size.width;
        subFrameWidth = (float)self.frame.size.height/(float)imageRatio;
        
        UIImageView *noteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(noteStartx,0, (int)subFrameWidth, self.frame.size.height)];
        noteImageView.image = noteImage;
        [self addSubview:noteImageView];
        [self.imageViewCollection insertObject:noteImageView atIndex:index];
        
        
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
    self.imageViewCollection = [[NSMutableArray alloc] initWithCapacity:8];
}

-(void)highlightNoteAtIndex:(NSInteger) index{
    if(index == 0) {
        [self removeHighlights];
        return;
    }
    UIImageView *imgView = [self.imageViewCollection objectAtIndex:index];
        
    if(self.noteHighlightOverlay == nil){
        self.noteHighlightOverlay = [[UIView alloc] init];
        self.noteHighlightOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self addSubview:self.noteHighlightOverlay];
    }
    self.noteHighlightOverlay.frame = imgView.frame;
 }
-(void)removeHighlights{
    [self.noteHighlightOverlay removeFromSuperview];
    self.noteHighlightOverlay = nil;
    
}
@end

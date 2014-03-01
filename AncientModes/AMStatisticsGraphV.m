//
//  AMStatisticsGraphV.m
//  AncientModes
//
//  Created by Vladimir Mollov on 2/25/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMStatisticsGraphV.h"

@implementation AMStatisticsGraphV
- (void)drawRect:(CGRect)rect{
    //clear the subviews
    for(UIView *subview in self.subviews) [subview removeFromSuperview];
    
    const int graphStartX = 35;
    const int paddingX = 20;
    const int paddingY = 6;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    int frameWidth = self.frame.size.width;
    int frameHeight = self.frame.size.height - 10;
    float graphBlockHeight = frameHeight - paddingY;
    float graphBlockWidth = frameWidth - paddingX - graphStartX;

    //draw horizontal indicators
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextBeginPath(context);
    
    for(int quarter = 0; quarter<5; quarter++){
        int y = ((graphBlockHeight/4) * quarter) + (paddingY/2); //the y coordinate of the indicator
        
        UILabel *lbPercent = [[UILabel alloc] initWithFrame:CGRectMake(3, y-10, graphStartX - 3, 20)];
        lbPercent.text = [NSString stringWithFormat:@"%i%%", 100 - (25*quarter)];
        [lbPercent setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:lbPercent];
        
        CGContextMoveToPoint(context, graphStartX, y);
        CGContextAddLineToPoint(context, frameWidth - 3, y);
    }
    CGContextStrokePath(context);
    
    //if no data display a label
    if([[self.data allKeys] count] == 0){
        UILabel *lbNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height/4)];
        lbNoData.text = @"No Data";
        lbNoData.textAlignment=NSTextAlignmentCenter;
        lbNoData.backgroundColor = [UIColor clearColor];
        lbNoData.textColor = [UIColor brownColor];
        lbNoData.font=[UIFont fontWithName:@"Verdana-Bold" size:39];
        [self addSubview:lbNoData];
        [self bringSubviewToFront:lbNoData];
        return;
    }
    
    //date format for the labels
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    //calculate the scale of the horizontal space based on the timespan between the earliest and latest timestamp
    NSArray *sortedDataKeys = [[self.data allKeys] sortedArrayUsingSelector:@selector(compare:)];
    time_t lowEnd = (time_t)[[sortedDataKeys firstObject] timeIntervalSince1970];
    time_t highEnd = (time_t) [[sortedDataKeys lastObject] timeIntervalSince1970];
    float graphTimeInterval = highEnd - lowEnd;
    float xZoomFactor = graphTimeInterval/graphBlockWidth;
    float yZoomFactor = graphBlockHeight/100;
    
    //draw the graph
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    //draw the initial dot
    int graphX = graphStartX + (paddingX/2);
    int graphY = graphBlockHeight+(paddingY/2)-([[self.data objectForKey:[sortedDataKeys firstObject]] intValue]*yZoomFactor);
    if([[self.data allKeys]count] == 1){
        //this is the only data point
        graphX = (graphBlockWidth/2) + (paddingX/2);
        CGContextFillEllipseInRect(context, CGRectMake(graphX-3, graphY-3, 6, 6));
        CGContextFillPath(context);
        //add the label
        UILabel *lbDate = [[UILabel alloc] initWithFrame:CGRectMake(graphX-18, frameHeight, 45, 10)];
        lbDate.text = [dateFormat stringFromDate:[sortedDataKeys firstObject]];
        lbDate.textAlignment=NSTextAlignmentCenter;
        [lbDate setFont:[UIFont systemFontOfSize:7]];
        [self addSubview:lbDate];
        
        return;
    }
    
    CGContextFillEllipseInRect(context, CGRectMake(graphX-3, graphY-3, 6, 6));
    CGContextFillPath(context);
    
    for(int dataPoint = 1; dataPoint<sortedDataKeys.count; dataPoint++){
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, graphX, graphY);
        
        NSDate *key = [sortedDataKeys objectAtIndex:dataPoint];
        time_t tCurrentPoint = (time_t)[key timeIntervalSince1970];
        
        long currentTimeAdjustedForLowEnd = tCurrentPoint - lowEnd;
        graphX = (currentTimeAdjustedForLowEnd/xZoomFactor) + graphStartX + (paddingX/2);
        graphY = graphBlockHeight + (paddingY/2) - ([[self.data objectForKey:key] intValue] * yZoomFactor);
        
        CGContextAddLineToPoint(context, graphX, graphY);
        CGContextStrokePath(context);
        
        CGContextFillEllipseInRect(context, CGRectMake(graphX-3, graphY-3, 6, 6));
        CGContextStrokePath(context);
    }
    
    //add date labels
    UILabel *lbEndDate = [[UILabel alloc] initWithFrame:CGRectMake(frameWidth - 40, frameHeight, 45, 10)];
    UILabel *lbStartDate = [[UILabel alloc] initWithFrame:CGRectMake(graphStartX - 10, frameHeight, 45, 10)];
    lbEndDate.text = [dateFormat stringFromDate:[sortedDataKeys lastObject]];
    lbStartDate.text = [dateFormat stringFromDate:[sortedDataKeys firstObject]];
    [lbEndDate setFont:[UIFont systemFontOfSize:7]];
    [lbStartDate setFont:[UIFont systemFontOfSize:7]];
    [self addSubview:lbEndDate];
    [self addSubview:lbStartDate];
}
@end

//
//  AMSettingsItem.m
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/8/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMSettingsItem.h"

@implementation AMSettingsItem
-(id)initWithTitleCellID:(NSString *)titleCellID contentCellID:(NSString *)contentCellID indexPathRow:(int)indexPathRow{
    if(self=[super init]){
        _titleCellID = titleCellID;
        _contentCellID = contentCellID;
        _indexPathRow = indexPathRow;
        _isShown = NO;
    }
    return self;
}
@end

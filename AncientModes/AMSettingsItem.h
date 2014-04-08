//
//  AMSettingsItem.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 4/8/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSettingsItem : NSObject
@property NSString *titleCellID, *contentCellID;
@property BOOL isShown;
@property BOOL contentIsDisplayed, titleIsDisplayed;
@property int indexPathRow;
@property float contentCellHeight;

-(id)initWithTitleCellID:(NSString *)titleCellID contentCellID:(NSString *)contentCellID indexPathRow:(int)indexPathRow;
@end

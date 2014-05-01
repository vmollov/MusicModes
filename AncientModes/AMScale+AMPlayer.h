//
//  AMScale+AMPlayer.h
//  Modes Ear Trainer
//
//  Created by Vladimir Mollov on 5/1/14.
//  Copyright (c) 2014 Vladimir Mollov. All rights reserved.
//

#import "AMScale.h"

@interface AMScale (AMPlayer)
-(MusicSequence)scaleSequenceAdjustedForPlayerRange;
-(MusicSequence)scaleSequenceAscAdjustedForPlayerRange;
-(MusicSequence)scaleSequenceDescAdjustedForPlayerRange;
@end

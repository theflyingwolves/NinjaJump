//
//  NJGameAttribute.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJGameAttribute.h"

@interface NJGameAttribute ()
@property int numberOfFramesToSpawnItem;
@end

@implementation NJGameAttribute

+ (id)attributeWithMode:(NJGameMode)mode
{
    return [[NJGameAttribute alloc] initAttributeWithGameMode:mode];
}

- (id)initAttributeWithGameMode:(NJGameMode)mode
{
    self.mode = mode;
    [self initItemFrequency];
    return self;
}

- (void)initItemFrequency
{
    switch (self.mode) {
        case NJGameModeOneVsThree:
            self.numberOfFramesToSpawnItem = 200;
            break;
        case NJGameModeBeginner:
            self.numberOfFramesToSpawnItem = 600;
            break;
        case NJGameModeSurvival:
            self.numberOfFramesToSpawnItem = 200;
            break;
        default:
            self.numberOfFramesToSpawnItem = 0;
            break;
    }
}

- (int)getNumberOfFramesToSpawnItem
{
    return self.numberOfFramesToSpawnItem;
}

- (BOOL)shouldApplyImpulesToSlowWoodpiles
{
    if (_mode != NJGameModeBeginner && _mode != NJGameModeTutorial) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)shouldWoodpileMove
{
    return _mode != NJGameModeBeginner && _mode != NJGameModeTutorial;
}

- (BOOL)shouldPileDecrease
{
    return _mode != NJGameModeBeginner && _mode != NJGameModeTutorial;
}

@end

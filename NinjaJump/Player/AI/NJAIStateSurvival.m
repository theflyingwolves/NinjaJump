//
//  NJAIStateSurvival.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateSurvival.h"
#import "NJAIPlayer.h"


@implementation NJAIStateSurvival


- (void)execute
{
    [self jumpWithFrequency:kAISurvivalJumpFrequency and:kAIJumpRandom];
}


@end

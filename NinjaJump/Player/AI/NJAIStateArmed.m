//
//  NJAIStateArmed.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateArmed.h"
#import "NJAIPlayer.h"

@implementation NJAIStateArmed


- (void)execute
{
    [self jumpWithFrequency:kAISurvivalJumpFrequency and:kAIJumpRandom];
    if(self.owner.item){
        [self useItemWithDistance:kAIArmedAttackRadius];
    }
}

@end

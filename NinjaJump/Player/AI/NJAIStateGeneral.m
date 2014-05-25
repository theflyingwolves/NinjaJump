//
//  NJAIStateGeneral.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateGeneral.h"
#import "NJAIPlayer.h"

@implementation NJAIStateGeneral



- (void)execute
{
    [self jumpWithFrequency:kAIGeneralJumpFrequency and:kAIJumpRandom];
    [self useItemWithDistance:kAIAlertRadius];
    [self changeState];
}




- (void)changeState
{
    if (self.jumpFlag && NJRandomValue() < kAIStateChangeFrequency) {
        [self.owner changeToState:WANDER];
    } else {
        self.jumpFlag = NO;
        if (self.owner.character.health < kAISurvivalHp) {
            [self.owner changeToState:SURVIVAL];
        }
        if (self.owner.item) {
            [self.owner changeToState:ARMED];
        }
    }
}

@end

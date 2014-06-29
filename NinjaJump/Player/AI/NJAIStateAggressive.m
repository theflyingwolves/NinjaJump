//
//  NJAIStateArmed.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateAggressive.h"
#import "NJAIPlayer.h"

@implementation NJAIStateAggressive

- (id)initWithOwner:(NJAIPlayer *)player
{
    self = [super initWithOwner:player];
    if (self) {
        self.alertDist = kAIGeneralAlertRadius;
    }
    return self;
}

- (void)execute
{
    [self jumpWithFrequency:kAISurvivalJumpFrequency];
    if(self.owner.item){
        [self useItemWithinRadius:kAIArmedAttackRadius];
    }
    [self changeState];
}

- (void)changeState
{
    if (!self.owner.item) {
        [self.owner changeToState:GENERAL];
    }
}

@end

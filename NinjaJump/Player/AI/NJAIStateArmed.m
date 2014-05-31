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
    [self jumpWithFrequency:kAISurvivalJumpFrequency and:kAIJumpRandom];
    if(self.owner.item){
        [self useItemWithRadius:kAIArmedAttackRadius];
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

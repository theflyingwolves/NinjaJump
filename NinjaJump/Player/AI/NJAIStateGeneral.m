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
    [self jumpWithFrequency:kAIGeneralJumpFrequency and:kAIJumpRandom];
    [self useItemWithRadius:kAIAlertRadius];
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
        else if (self.owner.item) {
            [self.owner changeToState:ARMED];
        }
    }
}

@end

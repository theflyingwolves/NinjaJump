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

- (id)initWithOwner:(NJAIPlayer *)player
{
    self = [super initWithOwner:player];
    if (self) {
        self.alertDist = kAISurvivalAlertRadius;
    }
    return self;
}

- (void)execute
{
    [self jumpWithFrequency:kAISurvivalJumpFrequency and:kAIJumpRandom];
    [self useItemWithRadius:kAIAlertRadius];
    [self changeState];
}

- (void)changeState
{
    if (self.owner.character.health > kAISurvivalHp) {
        [self.owner changeToState:GENERAL];
    }
}

@end

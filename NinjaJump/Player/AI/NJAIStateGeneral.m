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
    [self jumpWithFrequency:kAIGeneralJumpFrequency];
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
        else {
            switch (self.owner.characterType) {
                case GIANT:
                    if (![self isAnyRivalArmed]) {
                        [self.owner changeToState:AGGRESSIVE];
                    }
                    break;
                case ROBBER:
                    if (NJRandomValue() < kAIStateChangeFrequency) {
                        [self.owner changeToState:AGGRESSIVE];
                    }
                    break;
                case SHURIKEN_MASTER:
                    if (![self.owner.item isKindOfClass:[NJShuriken class]]) {
                        [self.owner changeToState:AGGRESSIVE];
                    }
                    break;
                case SCROLL_MASTER:
                    if (![self.owner.item isKindOfClass:[NJScroll class]]) {
                        [self.owner changeToState:AGGRESSIVE];
                    }
                    break;
                default:
                    if (self.owner.item) {
                        [self.owner changeToState:AGGRESSIVE];
                    }
                    break;
            }
        }

    }
}

- (BOOL)isAnyRivalArmed {
    for (NJPlayer *player in [self.delegate getAllPlayers]) {
        if ([self isRival:player] && !player.isDisabled && !player.character.dying && [player.item isKindOfClass:[NJScroll class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isRival:(NJPlayer *)player
{
    return player.teamId != self.owner.teamId ;
}

@end

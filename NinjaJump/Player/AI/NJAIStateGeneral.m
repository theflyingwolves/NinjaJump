//
//  NJAIStateGeneral.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateGeneral.h"

@implementation NJAIStateGeneral

- (void)enter
{
    
}

- (void)execute
{
    NJPile *pile = [self.delegate woodPileToJump:self.owner.character];
    if (pile && !self.owner.isJumping && self.owner.character.frozenCount == 0 && rand()/RAND_MAX>kAIJumpFrequency) {
        if (self.owner.jumpCooldown >= kJumpCooldownTime) {
            self.owner.jumpCooldown = 0;
            self.owner.fromPile = self.owner.targetPile;
            self.owner.targetPile = pile;
            self.owner.jumpRequested = YES;
            self.owner.isJumping = YES;
            if (rand()/RAND_MAX>kAIWanderFrequency) {
                [self.owner changeToState:WANDER];
            }
        }
    }
    if (self.owner.character.health<=kAISurvivalHp) {
        [self.owner changeToState:SURVIVAL];
    }
}

- (void)exit
{
    
}

@end

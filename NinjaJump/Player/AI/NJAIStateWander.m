//
//  NJAIStateWander.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateWander.h"
#import "NJAIPlayer.h"


@interface NJAIStateWander()

@property NJPile *prevPile;

@end

@implementation NJAIStateWander

- (void)enter
{
    
}

- (void)execute
{
    NJPile *pile = [self.delegate woodPileToJump:self.owner.character];
    if ((pile==_prevPile || _prevPile) && !self.owner.isJumping && self.owner.character.frozenCount == 0) {
        if (self.owner.jumpCooldown >= self.owner.character.JumpCoolTime) {
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
}

- (void)exit
{
    
}

@end

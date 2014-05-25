//
//  NJAIState.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIState.h"
#import "NJAIPlayer.h"

@implementation NJAIState

@synthesize owner;

- (id)initWithOwner:(NJAIPlayer *)player
{
    self = [super init];
    if(self){
        self.owner = player;
    }
    return self;
}

- (void)enter
{
    _jumpFlag = NO;
}

- (void)execute
{
    
}

- (void)exit
{

}

- (void)jumpWithFrequency:(CGFloat)frequency and:(BOOL)isWander
{
    
    NJPile *pile = [self.delegate woodPileToJump:self.owner.character];
    //If ninja jumps in wander mode, he will only choose the previously jumped woodpiles as target.
    if ([self.owner.prevPileList count]>=kAIprevPileNum && isWander) {
        if (![self.owner.prevPileList containsObject:pile]) {
            return;
        }
    }
    if (pile.itemHolded) {
        frequency = kAIItemJumpFrequency;
    }
    if (pile && !self.owner.isJumping && self.owner.character.frozenCount == 0 && NJRandomValue()<frequency && !pile.isOnFire) {
        if (self.owner.jumpCooldown >= kJumpCooldownTime) {
            self.owner.jumpCooldown = 0;
            self.owner.fromPile = self.owner.targetPile;
            self.owner.targetPile = pile;
            self.owner.jumpRequested = YES;
            self.owner.isJumping = YES;
            _jumpFlag = YES;
            [self.owner.prevPileList removeObject:pile];
            if (self.owner.fromPile) {
                [self.owner.prevPileList addObject:self.owner.fromPile];
            }
            for (NJPile *pile in self.owner.prevPileList) {
                if (pile && ![self.delegate containsPile:pile]) {
                    [self.owner.prevPileList removeObject:pile];
                }
            }
            if ([self.owner.prevPileList count] > kAIprevPileNum) {
                [self.owner.prevPileList removeObjectAtIndex:0];
            }
        }
    }
}

- (void)useItemWithDistance:(CGFloat)distance
{
    NJCharacter *nearestCharacter = [self.delegate getNearestCharacter:self.owner.character];
    CGFloat dist = NJDistanceBetweenPoints(self.owner.character.position, nearestCharacter.position);
    if (dist < kAIAlertRadius && self.owner.item) {
        [self.owner.character useItem:self.owner.item];
    }
}


- (void)changeState
{
    
}

@end

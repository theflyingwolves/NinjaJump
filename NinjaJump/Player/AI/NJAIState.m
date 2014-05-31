//
//  NJAIState.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIState.h"
#import "NJAIPlayer.h"
#import "NJMine.h"
#import "NJThunderScroll.h"
#import "NJWindScroll.h"
#import "NJFireScroll.h"
#import "NJIceScroll.h"
#import "NJShuriken.h"

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
    CGFloat nearestDist = [self getNearestCharDist];
    if (nearestDist<_alertDist) {
        frequency = kAIEscapeJumpFrequency;
    }
    if (pile.standingCharacter) {
        NSLog(@"%@ detect enemy in front",[self convertStateToString:owner.currStateType]);
        frequency = 1;
    }
    if (pile && !self.owner.isJumping && self.owner.character.frozenCount == 0 && NJRandomValue()<frequency && !pile.isOnFire) {
        if (self.owner.jumpCooldown >= kJumpCooldownTime) {
            if (frequency == 1) {
                NSLog( @"%@ jump to attack enemy",[self convertStateToString:owner.currStateType]);
            }
            self.owner.jumpCooldown = 0;
            self.owner.fromPile = self.owner.targetPile;
            self.owner.targetPile = pile;
            self.owner.jumpRequested = YES;
            self.owner.isJumping = YES;
            _jumpFlag = YES;
            [self updatePrevPileList];
        }
    }
}

- (void)useItemWithRadius:(CGFloat) attackRadius
{
    if ([self checkItemUsingWithRadius:attackRadius] && NJRandomValue()<kAIItemAttackFrequency) {
        [self.owner.character useItem:self.owner.item];
        NSLog(@"%@ Decide to use item",[self convertStateToString:owner.currStateType]);
    }
}

- (BOOL)checkItemUsingWithRadius:(CGFloat) attackRadius
{
    if ([self.owner.item isKindOfClass:[NJMine class]]) {
        return YES;
    }
    if ([self.owner.item isKindOfClass:[NJShuriken class]] && [self isNinjaTargeted:kAIAttackFireAngle andRadius:INFINITY]) {
        return YES;
    }
    if ([self.owner.item isKindOfClass:[NJFireScroll class]] && [self isNinjaTargeted:kAIAttackFireAngle andRadius:attackRadius]) {
        return YES;
    }
    if ([self.owner.item isKindOfClass:[NJWindScroll class]] && [self isNinjaTargeted:kAIAttackWindAngle andRadius:INFINITY]) {
        return YES;
    }
    if ([self.owner.item isKindOfClass:[NJThunderScroll class]] && [self isNinjaTargeted:2*M_PI andRadius:attackRadius]) {
        return YES;
    }
    if ([self.owner.item isKindOfClass:[NJThunderScroll class]] && [self isNinjaTargeted:2*M_PI andRadius:attackRadius]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNinjaTargeted: (CGFloat)attackAngle andRadius:(CGFloat)attackRadius
{
    if (attackAngle < 2*M_PI) {
        NJCharacter *nearestCharacter = [self.delegate getNearestCharacter:self.owner.character];
        CGFloat zRotation = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(nearestCharacter.position, self.owner.character.position));
        CGFloat ninjaZRotation = self.owner.character.zRotation;
        if (ninjaZRotation < 0) {
            float diff = ninjaZRotation + M_PI;
            ninjaZRotation = M_PI + diff;
        }
        CGFloat angleDiff = fabs(zRotation - ninjaZRotation);
        if (angleDiff > attackAngle && 2*M_PI-angleDiff > attackAngle) {
            return NO;
        }
    }

    //Compare dist and attack radius
    CGFloat dist = [self getNearestCharDist];
    if (dist > attackRadius) {
        return NO;
    }
    return YES;
}

- (CGFloat)getNearestCharDist
{
    NJCharacter *nearestCharacter = [self.delegate getNearestCharacter:self.owner.character];
    CGFloat dist = NJDistanceBetweenPoints(self.owner.character.position, nearestCharacter.position);
    return dist;
}

- (void)updatePrevPileList
{
    NJPile *pile = self.owner.targetPile;
    [self.owner.prevPileList removeObject:pile];
    if (self.owner.fromPile) {
        [self.owner.prevPileList addObject:self.owner.fromPile];
    }
    if ([self.owner.prevPileList containsObject:pile]) {
        [self.owner.prevPileList removeObject:pile];
    }
    for (NJPile *aPile in self.owner.prevPileList) {
        if (aPile && ![self.delegate containsPile:pile]) {
            [self.owner.prevPileList removeObject:pile];
        }
    }
    if ([self.owner.prevPileList count] > kAIprevPileNum) {
        [self.owner.prevPileList removeObjectAtIndex:0];
    }
}

- (void)changeState
{
    
}

- (NSString *)convertStateToString:(NJAIStateType) state
{
    switch(state){
        case GENERAL:
            return @"GENERAL"; break;
        case WANDER:
            return @"WANDER"; break;
        case SURVIVAL:
            return @"SURVIVAL"; break;
        case ARMED:
            return @"ARMED"; break;
    }
}

@end

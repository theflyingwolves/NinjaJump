//
//  NJNinjaCharacter.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJNinjaCharacter.h"
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"

@implementation NJNinjaCharacter

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player
{
    self = [super initWithTextureNamed:textureName AtPosition:position];
    
    if (self) {
        _player = player;
    }
    
    return self;
}

#pragma mark - Resets
- (void)resetPosition
{
    self.position = self.spawnPoint;
}

- (void)jumpToPosition:(CGPoint)position fromPosition:(CGPoint)from withTimeInterval:(NSTimeInterval)timeInterval arrayOfCharacters:(NSArray *)characters arrayOfItems:(NSArray *)items
{
    self.requestedAnimation = NJAnimationStateJump;
    self.animated = YES;
    CGPoint curPosition = self.position;
    CGFloat dx = position.x - curPosition.x;
    CGFloat dy = position.y - curPosition.y;
    CGFloat dt = self.movementSpeed * timeInterval;
    CGFloat distRemaining = hypotf(dx, dy);
    CGFloat ang = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(position, curPosition));
    self.zRotation = ang;
    if (distRemaining <= dt) {
        self.position = position;
        [self attackCharacterAtSamePosition:characters];
        [self pickupItemAtSamePosition:items];
    } else {
        self.position = CGPointMake(curPosition.x - sinf(ang)*dt,
                                    curPosition.y + cosf(ang)*dt);
    }
}

#pragma mark - Attack
- (void)attackCharacterAtSamePosition:(NSArray *)characters
{
    for (NJCharacter *character in characters) {
        if (CGPointEqualToPoint(character.position, self.position) && character.tag != self.tag) {
            [character applyDamage:20];
            [character resetPosition];
        }
    }
}

#pragma mark - Pickup Item
- (void)pickupItemAtSamePosition:(NSArray *)items{
    for (NJSpecialItem *item in items) {
        if (CGPointEqualToPoint(item.position, self.position)) {
            item.isPickedUp = YES;
            [item removeFromParent];
            self.player.item = item;
        }
    }
}

@end

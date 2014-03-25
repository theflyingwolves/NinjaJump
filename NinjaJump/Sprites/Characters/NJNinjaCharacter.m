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

const CGFloat medikitRecover = 40.0f;

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player
{
    self = [super initWithTextureNamed:textureName AtPosition:position];
    
    if (self) {
        _player = player;
    }
    
    return self;
}

#pragma mark - Pickup Item
- (void)pickupItemAtSamePosition:(NSArray *)items{
    for (NJSpecialItem *item in items) {
        if (CGPointEqualToPoint(item.position, self.position)) {
            switch (item.itemType) {
                case NJItemMedikit:
                    [self recover:medikitRecover];
                    break;
                    
                default:
                    break;
            }
            item.isPickedUp = YES;
            [item removeFromParent];
            self.player.item = item;
        }
    }
}

@end

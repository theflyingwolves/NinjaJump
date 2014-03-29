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
            item.isPickedUp = YES;
            [item removeFromParent];
            self.player.item = item;
            NSLog(@"picked up item: %@",self.player.item);
            
            switch (item.itemType) {
                case NJItemMedikit:
                    self.player.item = nil;
                    [self recover:medikitRecover];
                    break;
                
                case NJItemShuriken:
//                    [self useItem:item];
                    break;
                
                default:
                    break;
            }
        }
    }
}

#pragma mark - Use Items
- (void)useItem:(NJSpecialItem *)item
{
    CGFloat direction = (self.zRotation + M_PI/2);
    if (direction > (2*M_PI)) {
        direction -= 2*M_PI;
    }
    [item useAtPosition:self.position withDirection: direction];
    self.player.item = nil;
    
    NSLog(@"use item");
}

@end

//
//  NJSpecialItem.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
    NJItemThunderScroll = 0,
    NJItemWindScroll,
    NJItemIceScroll,
    NJItemFireScroll,
//    NJItemMine,
    NJItemShuriken,
    NJItemMedikit,
    NJItemCount
} NJItemType;


@interface NJSpecialItem : SKSpriteNode{
@protected NJItemType _itemType;
}


@property BOOL isPickedUp;
@property (readonly) NJItemType itemType;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position;


@end

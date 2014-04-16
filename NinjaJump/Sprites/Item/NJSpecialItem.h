//
//  NJSpecialItem.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJCharacter.h"
#import "NJRange.h"

typedef enum : uint8_t {
    NJItemThunderScroll = 0,
    NJItemWindScroll,
    NJItemIceScroll,
    NJItemFireScroll,
    NJItemMine,
    NJItemShuriken,
    NJItemMedikit,
    NJItemCount
} NJItemType;

@interface NJSpecialItem : SKSpriteNode{
@protected NJItemType _itemType;
}

@property BOOL isPickedUp;
@property (readonly) NJItemType itemType;
@property  float lifeTime;
@property (weak, nonatomic) NJMultiplayerLayeredCharacterScene *myParent;
@property NJRange *range;
@property SKSpriteNode *itemShadow;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position;

// EFFECTS: Update the next-frame state of the item on the screen
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

// EFFECTS: Use the item at a position with a direction (which is the zRotation of the player)
- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character;

@end

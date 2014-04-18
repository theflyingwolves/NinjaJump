//
//  NJSpecialItem.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    This class is the parent of all items in the game
*/

#import <SpriteKit/SpriteKit.h>
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJCharacter.h"
#import "NJRange.h"
#import "NJItemEffect.h"

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


#pragma mark - basic property
@property BOOL isPickedUp;
@property (readonly) NJItemType itemType;
@property  float lifeTime; //when life time > max life time, item will disappear
@property SKSpriteNode *itemShadow;
@property (weak, nonatomic) id<NJItemEffectSceneDelegate> myParent;

#pragma mark - item effect
@property NJRange *range; //rango of effect of the item



-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position;
//REQUIRES: textureName is valid (e.g. such texture exits); position is valid;
//MODIFIES: self
//EFFECTS: create an instance of this class
//RETURNS: an instance of this class

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;
// EFFECTS: Update the next-frame state of the item on the screen

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character;
// EFFECTS: Use the item at a position with a direction (which is the zRotation of the player)

@end

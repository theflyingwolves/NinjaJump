//
//  NJItemEffect.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJCharacter.h"

@class NJItemEffect;

@protocol NJItemEffectSceneDelegate <NSObject>
- (void)addEffect:(NJItemEffect*)effect;
@property (nonatomic, readwrite) NSMutableArray *woodPiles;// all the wood piles in the scene
@end


@interface NJItemEffect : SKSpriteNode{
@protected NSInteger _damage;
}

@property (readonly) NSInteger damage; //damage of the effect on character
@property (readonly, nonatomic, weak) NJCharacter *owner; //the character who creates the effect

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position onScene:(id<NJItemEffectSceneDelegate>)scene andOwner:(NJCharacter*)owner;
//REQUIRES: textureName is valid (e.g. such texture exits); position is valid; scene != nil; owner != nil
//MODIFIES: self
//EFFECTS: create an instance of this class, and add it to the scene
//RETURNS: an instance of this class


- (void)configurePhysicsBody;
//abstract method
//REQUIRES: self != nil
//MODIFIES: self
//EFFECTS: add physics property on self; after that self will be able to contact with NJCharater


@end

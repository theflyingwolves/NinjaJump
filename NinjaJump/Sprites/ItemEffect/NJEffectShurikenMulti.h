//
//  NJEffectShurikenMulti.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJItemEffect.h"
#import "NJMultiplayerLayeredCharacterScene.h"

@interface NJEffectShurikenMulti : NJItemEffect

@property (readonly) CGFloat direction; //in radians, same as definition of zPosition

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(id<NJItemEffectSceneDelegate>)scene andOwner:(NJCharacter*)owner;
//REQUIRES: position is valid; scene != nil; owner != nil; direction is valid
//MODIFIES: self
//EFFECTS: create an instance of this class, and add it to the scene
//RETURNS: an instance of this class

- (void)fireShuriken;
//REQUIRES: self != nil
//MODIFIES: self
//EFFECTS: make the shuriken to move on the scene

@end

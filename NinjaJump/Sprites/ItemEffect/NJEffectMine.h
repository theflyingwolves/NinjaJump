//
//  NJEffectMine.h
//  NinjaJump
//
//  Created by wulifu on 30/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJItemEffect.h"

@interface NJEffectMine : NJItemEffect

@property (readonly) NJPile *pile;

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(id<NJItemEffectSceneDelegate>)scene andOwner:(NJCharacter*)owner;
//REQUIRES: position is valid; scene != nil; owner != nil; direction is valid
//MODIFIES: self
//EFFECTS: create an instance of this class, and add it to the scene
//RETURNS: an instance of this class


- (void)performEffect;
//REQUIRES: self != nil
//MODIFIES: self
//EFFECTS: make the bomb appear for 1 sec and disappear



@end

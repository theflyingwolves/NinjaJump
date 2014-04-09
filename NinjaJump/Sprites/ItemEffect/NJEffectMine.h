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

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner;

- (void)performEffect;

@end

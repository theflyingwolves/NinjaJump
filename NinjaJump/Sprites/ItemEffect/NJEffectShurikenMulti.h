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

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner;

- (void)fireShuriken;

@end

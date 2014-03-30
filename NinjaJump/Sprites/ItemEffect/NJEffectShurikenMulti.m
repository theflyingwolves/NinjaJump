//
//  NJEffectShurikenMulti.m
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJEffectShurikenMulti.h"
#import "NJGraphicsUnitilities.h"

#define kShurikenEffectFileName @"shurikenEffect.png"
#define kShurikenSpeed 800
#define kShurikenMaxDistance 1500

@implementation NJEffectShurikenMulti

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene{
    self = [super initWithTextureNamed:kShurikenEffectFileName atPosition:position onScene:scene];
    if (self) {
        _direction = direction;
        CGVector movement = vectorForMovement(direction, kShurikenMaxDistance);
        [self runAction:[SKAction moveByX:movement.dx y:movement.dy duration:kShurikenMaxDistance/kShurikenSpeed] completion:^{[self removeFromParent];}];
//        [scene addNode:self atWorldLayer:NJWorldLayerCharacter];
    }
    return self;
}

@end
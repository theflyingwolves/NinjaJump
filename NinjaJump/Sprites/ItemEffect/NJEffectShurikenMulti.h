//
//  NJEffectShurikenMulti.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJItemEffect.h"

#define kShurikenSpeed 100;

@interface NJEffectShurikenMulti : NJItemEffect

@property (readonly) CGFloat direction; //in radians, same as definition of zPosition

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction;

// EFFECTS: Update the next-frame renderring of the pile
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;


@end

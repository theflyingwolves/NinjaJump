//
//  NJItemEffect.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NJItemEffect : SKSpriteNode

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position;

// EFFECTS: Update the next-frame renderring of the pile
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

@end

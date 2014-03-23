//
//  NJHPBar.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 23/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class NJPlayer;

@interface NJHPBar : SKSpriteNode
+ (NJHPBar *)hpBarWithPosition:(CGPoint)position andPlayer:(NJPlayer *)player;
- (void)updateHealthPoint;
@end

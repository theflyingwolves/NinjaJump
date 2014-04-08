//
//  NJLevelSceneLakeMoon.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 8/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLevelSceneLakeMoon.h"

@implementation NJLevelSceneLakeMoon

- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"lakeMoonBG"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
}

@end
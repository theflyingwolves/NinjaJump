//
//  NJLevelSceneWaterPark.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLevelSceneWaterPark.h"

#define kBackGroundFileName @"waterParkBG.jpg"

@implementation NJLevelSceneWaterPark

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:kBackGroundFileName];
    bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:bg atWorldLayer:NJWorldLayerGround];
    return self;
}
@end

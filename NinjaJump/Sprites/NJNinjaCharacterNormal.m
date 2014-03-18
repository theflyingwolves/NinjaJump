//
//  NJNinjaCharacterNormal.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//
#define NUM_OF_FRAMES_FOR_NORMAL_NINJA_JUMP 10

#import "NJNinjaCharacterNormal.h"
#import "NJGraphicsUnitilities.h"

@implementation NJNinjaCharacterNormal
+ (void)loadSharedAssets
{
    [super loadSharedAssets];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedJumpAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:@"ninja_normal_jump" withBaseName:@"ninja_jump_atlas_" andNumOfFrames:NUM_OF_FRAMES_FOR_NORMAL_NINJA_JUMP];
    });
}

static NSArray *sSharedJumpAnimationFrames;
- (NSArray *)jumpAnimationFrames
{
    return sSharedJumpAnimationFrames;
}

@end

//
//  NJNinjaCharacterBoss.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#define NUM_OF_FRAMES_FOR_BOSS_NINJA_JUMP 18
#define NUM_OF_FRAMES_FOR_BOSS_NINJA_DEATH 10
#define NUM_OF_FRAMES_FOR_BOSS_NINJA_ATTACK 6
#define NUM_OF_FRAMES_FOR_BOSS_NINJA_THUNDER 6
#define BOSS_THUNDER_ANIMATION_FRAMES_ATLAS_NAME @"Ninja_Thunder"
#define BOSS_THUNDER_ANIMATION_FRAMES_BASE_NAME @"ninja_thunder_"
#define BOSS_ATTACK_ANIMATION_FRAMES_ATLAS_NAME @"Ninja_Attack"
#define BOSS_ATTACK_ANIMATION_FRAMES_BASE_NAME @"attack_light_"
#define BOSS_JUMP_ANIMATION_FRAMES_ATLAS_NAME @"Boss_Jump"
#define BOSS_JUMP_ANIMATION_FRAMES_BASE_NAME @"bossJump_"

#import "NJNinjaCharacterBoss.h"
#import "NJGraphicsUnitilities.h"
#import "NJConstants.h"

@implementation NJNinjaCharacterBoss

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player delegate:(id<NJCharacterDelegate>)delegate
{
    self = [super initWithTextureNamed:textureName atPosition:position withPlayer:player delegate:delegate];
    if (self) {
        self.magicalDamageMultiplier = 0.5f;
        self.physicalDamageMultiplier = 0.5f;
        self.addItemTimer = 0.0f;
        self.needsAddItem = YES;
    }
    return self;
}

+ (void)loadSharedAssets
{
    [super loadSharedAssets];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedJumpAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:BOSS_JUMP_ANIMATION_FRAMES_ATLAS_NAME withBaseName:BOSS_JUMP_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_JUMP];
        sSharedAttackAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:BOSS_ATTACK_ANIMATION_FRAMES_ATLAS_NAME withBaseName:BOSS_ATTACK_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_ATTACK];
        sSharedThunderAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:BOSS_THUNDER_ANIMATION_FRAMES_ATLAS_NAME withBaseName:BOSS_THUNDER_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_THUNDER];
    });
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    [super updateWithTimeSinceLastUpdate:interval];
    self.addItemTimer += interval;
    if (self.addItemTimer>=kTimeAddItemToBoss) {
        self.addItemTimer = 0;
        self.needsAddItem = YES;
    }
}

static NSArray *sSharedJumpAnimationFrames;
- (NSArray *)jumpAnimationFrames
{
    return sSharedJumpAnimationFrames;
}

static NSArray *sSharedAttackAnimationFrames;
- (NSArray *)attackAnimationFrames
{
    return sSharedAttackAnimationFrames;
}

static NSArray *sSharedThunderAnimationFrames;
- (NSArray *)thunderAnimationFrames
{
    return sSharedThunderAnimationFrames;
}

@end

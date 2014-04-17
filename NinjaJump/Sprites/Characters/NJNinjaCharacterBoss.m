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

#import "NJNinjaCharacterBoss.h"
#import "NJGraphicsUnitilities.h"
#import "NJConstants.h"

@implementation NJNinjaCharacterBoss

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player
{
    self = [super initWithTextureNamed:textureName atPosition:position withPlayer:player];
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
        sSharedJumpAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:@"Boss_Jump" withBaseName:@"bossJump_" andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_JUMP];
        sSharedAttackAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:@"Ninja_Attack" withBaseName:@"attack_light_" andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_ATTACK];
        sSharedThunderAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:@"Ninja_Thunder" withBaseName:@"ninja_thunder_" andNumOfFrames:NUM_OF_FRAMES_FOR_BOSS_NINJA_THUNDER];
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

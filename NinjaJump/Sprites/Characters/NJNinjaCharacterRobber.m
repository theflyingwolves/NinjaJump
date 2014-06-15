//
//  NJNinjaCharacterRobber.m
//  NinjaJump
//
//  Created by wulifu on 7/6/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#define NUM_OF_FRAMES_FOR_NORMAL_NINJA_JUMP 17
#define NUM_OF_FRAMES_FOR_NORMAL_NINJA_DEATH 10
#define NUM_OF_FRAMES_FOR_NORMAL_NINJA_ATTACK 6
#define NUM_OF_FRAMES_FOR_NORMAL_NINJA_THUNDER 6
#define THUNDER_ANIMATION_FRAMES_ATLAS_NAME @"Ninja_Thunder"
#define THUNDER_ANIMATION_FRAMES_BASE_NAME @"ninja_thunder_"
#define ATTACK_ANIMATION_FRAMES_ATLAS_NAME @"Ninja_Attack"
#define ATTACK_ANIMATION_FRAMES_BASE_NAME @"attack_light_"
#define JUMP_ANIMATION_FRAMES_ATLAS_NAME @"Ninja_Jump"
#define JUMP_ANIMATION_FRAMES_BASE_NAME @"ninja_jump_"

#import "NJGraphicsUnitilities.h"
#import "NJNinjaCharacterRobber.h"
#import "NJPlayer.h"

@implementation NJNinjaCharacterRobber

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player delegate:(id<NJCharacterDelegate>)delegate
{
    self = [super initWithTextureNamed:textureName atPosition:position withPlayer:player delegate:delegate];
    if (self) {
        //wait for adjustment
        self.strength = 80;
        self.vitality = 50;
        self.intellect = 80;
        self.agility = 150;
        [self initActualAbility];
    }
    return self;
}

- (void)attackCharacter:(NJCharacter *)character
{
    [super attackCharacter:character];
    if (character.player.item) {
        self.player.item = character.player.item;
        character.player.item = NULL;
    }
}


+ (void)loadSharedAssets
{
    [super loadSharedAssets];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedJumpAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:JUMP_ANIMATION_FRAMES_ATLAS_NAME withBaseName:JUMP_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_NORMAL_NINJA_JUMP];
        sSharedAttackAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:ATTACK_ANIMATION_FRAMES_ATLAS_NAME withBaseName:ATTACK_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_NORMAL_NINJA_ATTACK];
        sSharedThunderAnimationFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:THUNDER_ANIMATION_FRAMES_ATLAS_NAME withBaseName:THUNDER_ANIMATION_FRAMES_BASE_NAME andNumOfFrames:NUM_OF_FRAMES_FOR_NORMAL_NINJA_THUNDER];
    });
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

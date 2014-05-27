//
//  NJPlayer.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPlayer.h"
#import "NJNinjaCharacter.h"
#import "NJGraphicsUnitilities.h"
#import "NJMultiplayerLayeredCharacterScene.h"

#define NUM_OF_FRAMES_FOR_JUMP_TIMER 9

@implementation NJPlayer

- (void)runJumpTimerAction
{
    if (self.character) {
//    if (self.ninja) {
        if (self.jumpTimerSprite.parent) {
            [self.jumpTimerSprite removeAllActions];
            [self.jumpTimerSprite removeFromParent];
        }
        self.jumpTimerSprite.position = self.character.position;
        [self.character.parent addChild:self.jumpTimerSprite];
//        self.jumpTimerSprite.position = self.ninja.position;
//        [self.ninja.parent addChild:self.jumpTimerSprite];
        float jumpAnimationSpeed = self.character.JumpCoolTime / NUM_OF_FRAMES_FOR_JUMP_TIMER;
        [self.jumpTimerSprite runAction:[SKAction animateWithTextures:sSharedJumpTimerFrames timePerFrame:jumpAnimationSpeed resize:YES restore:YES] completion:^{
            [self.jumpTimerSprite removeFromParent];
        }];
    }
}

- (SKSpriteNode *)jumpTimerSprite
{
    if (!_jumpTimerSprite) {
        _jumpTimerSprite = [[SKSpriteNode alloc] init];
    }
    return _jumpTimerSprite;
}

+ (void)loadSharedAssets
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedJumpTimerFrames = [NJGraphicsUnitilities NJLoadFramesFromAtlas:@"Jump_Timer" withBaseName:@"jump_timer_" andNumOfFrames:NUM_OF_FRAMES_FOR_JUMP_TIMER];
    });
}

static NSArray *sSharedJumpTimerFrames;
- (NSArray *)jumpTimerFrames
{
    return sSharedJumpTimerFrames;
}

@end
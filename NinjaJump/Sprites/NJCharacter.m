//
//  NJCharacter.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJCharacter.h"

@implementation NJCharacter

+(instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    return (NJCharacter *)[SKSpriteNode spriteNodeWithImageNamed:name];
}

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position
{
    self = [NJCharacter spriteNodeWithImageNamed:textureName];
    if (self) {
        self.position = position;
    }
    
    return self;
}

- (void)jumpToPosition:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval
{
    self.requestedAnimation = NJAnimationStateJump;
}

- (void)update
{
    if (self.isAnimated) {
        [self resolveRequestedAnimation];
    }
}

#pragma mark - Animation
- (void)resolveRequestedAnimation
{
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    NJAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
        case NJAnimationStateJump:
            animationKey = @"anim_jump";
            animationFrames = [self jumpAnimationFrames];
            break;
            
        default:
            break;
    }
    
    if (animationKey) {
        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
    }
}

- (void)fireAnimationForState:(NJAnimationState)animationState usingTextures:(NSArray *)animationFrames withKey:(NSString *)animationKey
{
    SKAction *animAction = [self actionForKey:animationKey];
    if (animAction || [animationFrames count] < 1) {
        return; // we already have a running animation or there aren't any frames to animate
    }
    
    self.activeAnimationKey = animationKey;
    [self runAction:[SKAction sequence:@[
                                         [SKAction animateWithTextures:animationFrames timePerFrame:self.animationSpeed resize:YES restore:NO],
                                         [SKAction runBlock:^{
        [self animationHasCompleted:animationState];
    }]]] withKey:animationKey];
}

- (void)animationHasCompleted:(NJAnimationState)animationState
{
    self.activeAnimationKey = nil;
}

- (NSArray *)jumpAnimationFrames
{
    // To Be Implemented by subclasses
    return nil;
}
@end
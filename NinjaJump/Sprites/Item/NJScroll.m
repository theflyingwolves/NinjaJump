//
//  NJScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJScroll.h"
#import "NJCharacter.h"

@implementation NJScroll

- (id)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate
{
    // Overridden By Subclasses
    return nil;
}

- (void)fireAttackedAnimation:(NJCharacter *)character
{
    UIColor *ninjaColor = character.color;
    UIColor *hurtColor = [UIColor whiteColor];
    SKAction *colorize = [SKAction colorizeWithColor:hurtColor colorBlendFactor:1 duration:0.0];
    SKAction *wait = [SKAction waitForDuration:0.3];
    SKAction *colorizeBack = [SKAction colorizeWithColor:ninjaColor colorBlendFactor:kNinjaColorBlendFactor duration:0.0];
    SKAction *colorizeSequence = [SKAction sequence:@[colorize,wait,colorizeBack,wait,]];
    SKAction *repeatColorizing = [SKAction repeatAction:colorizeSequence count:5];
    [character runAction:repeatColorizing withKey:@"anim_attacked"];
}

@end

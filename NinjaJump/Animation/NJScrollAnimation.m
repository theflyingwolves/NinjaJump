//
//  NJScrollAnimation.m
//  NinjaJump
//
//  Created by Wang Yichao on 30/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJScrollAnimation.h"

@implementation NJScrollAnimation{
    SKEmitterNode *fireAttack;
    SKEmitterNode *freezeEffect;
}

- (void)runFireEffect:(NJNinjaCharacter *)ninja{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FireEffect" ofType:@"sks"];
    fireAttack = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    fireAttack.particleScale = 2;
    fireAttack.position = CGPointMake(0, 50);
    [ninja addChild:fireAttack];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fireUp:) userInfo:nil repeats:5];
    SKAction *move = [SKAction moveByX:0 y:100 duration:0.6];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[move, removeNode]];
    [fireAttack runAction:sequence completion:^{
        fireAttack = nil;
        [timer invalidate];
    }];
}

- (void)fireUp:(NSTimer *)timer{
    fireAttack.particleScale = fireAttack.particleScale+1;
}

- (void)runFreezeEffect:(NJNinjaCharacter *)ninja{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FreezeEffect" ofType:@"sks"];
    freezeEffect = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    freezeEffect.particleBirthRate = 10;
    [ninja addChild:freezeEffect];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(freezeUp:) userInfo:nil repeats:5];
}

- (void)freezeUp:(NSTimer *)timer{
    freezeEffect.particleBirthRate ++;
    if (freezeEffect.particleBirthRate == 40) {
        freezeEffect.particleBirthRate = 10;
        freezeEffect.particleAlpha =0.1;
        SKAction *wait = [SKAction waitForDuration:0.2];
        SKAction *fadeout = [SKAction fadeAlphaBy:0.3 duration:0.2];
        [freezeEffect runAction:wait completion:^{
            [freezeEffect removeFromParent];
            [timer invalidate];
        }];
    }
}

@end

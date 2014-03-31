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
    fireAttack.zRotation = ninja.zRotation;
    fireAttack.position = CGPointMake(ninja.position.x-50*sin(ninja.zRotation), ninja.position.y+50*cos(ninja.zRotation));
    [ninja.parent addChild:fireAttack];
    
    NSLog(@"ninja rotate %f",ninja.zRotation);
    //[fireAttack runAction:sequence];
    [self performSelector:@selector(moveFire) withObject:nil afterDelay:1.5];
}

- (void)moveFire{
    [fireAttack removeFromParent];
}

- (void)runFreezeEffect:(NJNinjaCharacter *)ninja{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FreezeEffect" ofType:@"sks"];
    freezeEffect = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    freezeEffect.particleBirthRate = 10;
    freezeEffect.position = ninja.position;
    [ninja.parent addChild:freezeEffect];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(freezeUp:) userInfo:nil repeats:5];
}

- (void)freezeUp:(NSTimer *)timer{
    freezeEffect.particleBirthRate ++;
    if (freezeEffect.particleBirthRate == 40) {
        freezeEffect.particleBirthRate = 10;
        //SKAction *wait = [SKAction waitForDuration:0.2];
        SKAction *fadeout = [SKAction fadeAlphaBy:0.7 duration:0.2];
        [freezeEffect runAction:fadeout completion:^{
            [freezeEffect removeFromParent];
            [timer invalidate];
        }];
    }
}

@end

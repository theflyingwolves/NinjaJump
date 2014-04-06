//
//  NJScrollAnimation.m
//  NinjaJump
//
//  Created by Wang Yichao on 30/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJScrollAnimation.h"

@implementation NJScrollAnimation

- (void)runFireEffect:(NJNinjaCharacter *)ninja{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FireEffect" ofType:@"sks"];
    SKEmitterNode *fireAttack = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    fireAttack.zRotation = ninja.zRotation;
    fireAttack.position = CGPointMake(ninja.position.x-50*sin(ninja.zRotation), ninja.position.y+50*cos(ninja.zRotation));
    [ninja.parent addChild:fireAttack];
    
    NSLog(@"ninja rotate %f",ninja.zRotation);
    //[fireAttack runAction:sequence];
    [self performSelector:@selector(fadeOut:) withObject:fireAttack afterDelay:1.5];
}



- (void)runFreezeEffect:(NJNinjaCharacter *)ninja{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FreezeEffect" ofType:@"sks"];
    SKEmitterNode *freezeEffect = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    freezeEffect.particleBirthRate = 10;
    freezeEffect.position = ninja.position;
    [ninja.parent addChild:freezeEffect];
    [self performSelector:@selector(fadeOut:) withObject:freezeEffect afterDelay:0.8];

}

- (void)fadeOut:(SKEmitterNode *)particleEmitter{
    particleEmitter.particleBirthRate = 0;
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[wait,removeNode]];
    [particleEmitter runAction:sequence];
}

@end

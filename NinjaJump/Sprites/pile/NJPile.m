//
//  NJPile.m
//  NinjaJump
//
//  Created by wulifu on 19/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPile.h"
#import "NJCharacter.h"
#import "NJMultiplayerLayeredCharacterScene.h"

@implementation NJPile{
    BOOL isRotating;
    BOOL isMoving;
}

#define rotatetime 1

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withSpeed:(float)speed angularSpeed:(float)aSpeed direction:(NJDirection)direction
{
    self = [super initWithImageNamed:textureName];
    if (self) {
        self.position = position;
        if (speed < 0.1) {
            isMoving = NO;
        } else {
            isMoving = YES;
        }
        self.speed = speed;
        if (aSpeed < 0.1) {
            isRotating = NO;
        } else {
            isRotating = YES;
        }
        if (direction == NJDiectionClockwise) {
            self.angularSpeed = -aSpeed;
        } else {
            self.angularSpeed = aSpeed;
        }
        self.rotateDirection = direction;
        [self configurePhysicsBody];
    }
    
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    if (self.isOnFire) {
        if (self.fireTimer<kFireLastTime) {
            self.fireTimer += interval;
            if (!self.fireEmitter) {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WoodFire" ofType:@"sks"];
                self.fireEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                [self addChild:self.fireEmitter];
            }
        } else {
            self.fireTimer = 0;
            self.isOnFire = NO;
            [self.fireEmitter removeFromParent];
            self.fireEmitter = nil;
        }
    }
    if (isRotating) {
        float angle = self.angularSpeed*interval;
        self.angleRotatedSinceLastUpdate = angle;
        self.zRotation += angle;
        while (self.zRotation>=2*M_PI) {
            self.zRotation -= 2*M_PI;
        }
        while (self.zRotation<0) {
            self.zRotation += 2*M_PI;
        }
    }
}


- (void)addCharacterToPile:(NJCharacter *)character
{
    self.standingCharacter = character;
}

- (void)setSpeed:(float)aSpeed direction:(NJDirection)direction
{
    if (direction == NJDiectionClockwise) {
        self.angularSpeed = -aSpeed;
    } else {
        self.angularSpeed = aSpeed;
    }
}

- (void)removeStandingCharacter
{
    self.standingCharacter = nil;
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:CGRectGetWidth(self.frame)/2];
    self.physicsBody.categoryBitMask = NJColliderTypeWoodPile;
    self.physicsBody.collisionBitMask = NJColliderTypeWoodPile;
    self.physicsBody.dynamic = YES;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.density = 0.2;
    self.physicsBody.friction = 0.0;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.restitution = 1.0;
}


@end

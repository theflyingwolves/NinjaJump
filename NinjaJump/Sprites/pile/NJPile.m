//
//  NJPile.m
//  NinjaJump
//
//  Created by wulifu on 19/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPile.h"

@implementation NJPile{
    BOOL isRotating;
    BOOL isMoving;
}

#define rotatetime 1

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withSpeed:(float)speed angularSpeed:(float)aSpeed direction:(NJDirection)direction path:(NJPath *)path
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
        self.path = path;
    }
    
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval
{
    if (isRotating) {
        float angle = self.angularSpeed*interval;
        self.angleRotatedSinceLastUpdate = angle;
        self.zRotation += angle;
        while (self.zRotation>=2*M_PI) {
            self.zRotation -= 2*M_PI;
        }
    }
    if (isMoving) {
        NJPath *path = self.path;
        NSDictionary *state = [path updateStateAfterTimeInterval:interval withSpeed:self.speed];
        CGPoint newPosition = [((NSValue*)state[@"position"]) CGPointValue];
        self.position = newPosition;
    }
}

- (CGPoint)positionAfterTimeinterval:(CFTimeInterval)interval{
    NSDictionary *state = [self.path  stateAfterTimeInterval:interval withSpeed:self.speed];
    CGPoint position = [((NSValue*)state[@"position"]) CGPointValue];;
    return position;
}





@end

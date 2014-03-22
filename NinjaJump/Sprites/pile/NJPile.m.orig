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

/*
+(instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    return (NJPile *)[SKSpriteNode spriteNodeWithImageNamed:name];
}
*/
-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withSpeed:(float)speed angularSpeed:(float)aSpeed path:(NJPath *)path
{
    self = [super initWithImageNamed:textureName];
    if (self) {
<<<<<<< HEAD
        //self = [NJPile spriteNodeWithImageNamed:textureName];
=======
>>>>>>> origin/WLFPile
        self.position = position;
        isRotating = YES;
        isMoving = YES;
        self.speed = speed;
        self.angularSpeed = aSpeed;
        self.path = path;
    }
    
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval
{
    if (isRotating) {
        float angle = self.angularSpeed*interval;
        self.zRotation += angle;
    }
    if (isMoving) {
        NJPath *path = self.path;
        float speed = self.speed;
        NSDictionary *state = [path updateStateAfterTimeInterval:interval withSpeed:self.speed];
        CGPoint newPosition = [((NSValue*)state[@"position"]) CGPointValue];
//        NSLog(@"x: %f, y: %f", newPosition.x, newPosition.y);
        NSLog(@"reverse: %d", [((NSNumber*)state[@"moveReverse"]) integerValue]);
        self.position = newPosition;
    }
}

- (CGPoint)positionAfterTimeinterval:(CFTimeInterval)interval{
    NSDictionary *state = [self.path  stateAfterTimeInterval:interval withSpeed:self.speed];
    CGPoint position = [((NSValue*)state[@"position"]) CGPointValue];;
    return position;
}





@end

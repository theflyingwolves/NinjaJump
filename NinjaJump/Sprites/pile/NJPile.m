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
        self = [NJPile spriteNodeWithImageNamed:textureName];
        self.position = position;
        isRotating = YES;
        self.speed = speed;
        self.angularSpeed = aSpeed;
        self.path = path;
    }
    
    return self;
}

-(void)initializeWithSpeed:(float)speed andAngularSpeed:(float)aSpeed andPath:(NJPath*)path{
    self.speed = speed;
    self.angularSpeed = aSpeed;
    self.path = path;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval
{
    if (isRotating) {
        float angle = self.angularSpeed*interval;
        self.zRotation += angle;
    }
}





@end

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
    BOOL initialized;
}

#define rotatetime 1

+(instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    return (NJPile *)[SKSpriteNode spriteNodeWithImageNamed:name];
}

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position
{
    self = [NJPile spriteNodeWithImageNamed:textureName];
    if (self) {
        self.position = position;
        isRotating = NO;
    }
    
    return self;
}

-(void)initializeWithSpeed:(float)speed andAngularSpeed:(float)aSpeed andPath:(NJPath*)path{
    self.speed = speed;
    self.angularSpeed = aSpeed;
    self.path = path;
    initialized = YES;
}

- (void)update
{
    if (initialized) {
        if (!isRotating) {
            [self runAction:[SKAction rotateByAngle:self.angularSpeed*2 duration:2] completion:^{
                isRotating = NO;
            }];
        }
    }
}





@end

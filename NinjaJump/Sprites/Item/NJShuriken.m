//
//  NJShuriken.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJShuriken.h"
#import "NJEffectShurikenMulti.h"

#define kShurikenAngle 30

@implementation NJShuriken

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemShuriken;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    int angle1 = 0 - kShurikenAngle/2;
    int angle2 = 0;
    int angle3 = kShurikenAngle - kShurikenAngle/2;
    
    float direction1 = (angle1/360.0)*(2*M_PI) + direction;
    float direction2 = (angle2/360.0)*(2*M_PI) + direction;
    float direction3 = (angle3/360.0)*(2*M_PI) + direction;
    if (direction1 > 2*M_PI) {
        direction1 -= 2*M_PI;
    } else if (direction1 < 0){
        direction1 += 2*M_PI;
    }
    
    if (direction2 > 2*M_PI) {
        direction2 -= 2*M_PI;
    } else if (direction2 < 0){
        direction2 += 2*M_PI;
    }
    
    if (direction3 > 2*M_PI) {
        direction3 -= 2*M_PI;
    } else if (direction3 < 0){
        direction3 += 2*M_PI;
    }
    
    //create 3 shurikens to be thrown out
    NJEffectShurikenMulti *shuriken1 = [[NJEffectShurikenMulti alloc] initAtPosition:position withDirection:direction1 onScene:self.myParent andOwner:character];
    
    NJEffectShurikenMulti *shuriken2 = [[NJEffectShurikenMulti alloc] initAtPosition:position withDirection:direction2 onScene:self.myParent andOwner:character];
    
    NJEffectShurikenMulti *shuriken3 = [[NJEffectShurikenMulti alloc] initAtPosition:position withDirection:direction3 onScene:self.myParent andOwner:character];
    
    [shuriken1 fireShuriken];
    [shuriken2 fireShuriken];
    [shuriken3 fireShuriken];
}

@end

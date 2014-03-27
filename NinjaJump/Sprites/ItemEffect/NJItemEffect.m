//
//  NJItemEffect.m
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJItemEffect.h"

@implementation NJItemEffect

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithImageNamed:textureName];
    if (self) {
        self.position = position;
    }
    return self;
}

@end

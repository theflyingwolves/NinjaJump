//
//  NJShuriken.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJShuriken.h"
#import "NJEffectShurikenMulti.h"

@implementation NJShuriken

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemShuriken;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction{
    NJEffectShurikenMulti *effect = [[NJEffectShurikenMulti alloc] initAtPosition:position withDirection:direction onScene:self.myParent];
}

@end

//
//  NJMine.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMine.h"

@implementation NJMine

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
//        _itemType = NJItemMine;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withRotation:(CGFloat)zRotation{
    
}

@end

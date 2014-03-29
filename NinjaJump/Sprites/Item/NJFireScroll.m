//
//  NJFireScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJFireScroll.h"

@implementation NJFireScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemFireScroll;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction andWoodPiles:(NSArray *)piles
{
    
}

@end
//
//  NJTutorialScene.m
//  NinjaJump
//
//  Created by wulifu on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTutorialScene.h"
#import "NJPlayer.h"

#define kMainPlayerIndex 0
#define kPuppetPlayerIndex 1

@implementation NJTutorialScene

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSizeWithoutSelection:size];
    if (self){
        ((NJPlayer*)self.players[kMainPlayerIndex]).isDisabled = NO;
        ((NJPlayer*)self.players[kPuppetPlayerIndex]).isDisabled = NO;
    }
    
    return  self;
}

@end

//
//  NJTutorialScene.m
//  NinjaJump
//
//  Created by wulifu on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTutorialScene.h"
#import "NJPlayer.h"

@implementation NJTutorialScene

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSizeWithoutSelection:size];
    if (self){
        ((NJPlayer*)self.players[0]).isDisabled = NO;
        ((NJPlayer*)self.players[1]).isDisabled = NO;
        ((NJPlayer*)self.players[2]).isDisabled = YES;
        ((NJPlayer*)self.players[3]).isDisabled = YES;
        [self activateSelectedPlayersWithPreSetting];
    }
    
    return  self;
}

@end

//
//  NJAIStateWander.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIStateWander.h"
#import "NJAIPlayer.h"


@interface NJAIStateWander()


@end

@implementation NJAIStateWander

- (void)enter
{
    [super enter];
    NSLog(@"enter wander");
}

- (void)execute
{
    [self jumpWithFrequency:kAIGeneralJumpFrequency and:kAIJumpWandering];
    [self changeState];
}

- (void)changeState
{
    NJCharacter *nearestCharacter = [self.delegate getNearestCharacter:self.owner.character];
    CGFloat dist = NJDistanceBetweenPoints(self.owner.character.position, nearestCharacter.position);
    if (dist < kAIAlertRadius) {
        [self.owner changeToState:GENERAL];
    }
}

@end

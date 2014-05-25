//
//  NJAIPlayer.m
//  NinjaJump
//
//  Created by wulifu on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIPlayer.h"
#import "NJAIStateArmed.h"
#import "NJAIStateGeneral.h"
#import "NJAIStateSurvival.h"
#import "NJAIStateWander.h"


@implementation NJAIPlayer

- (id) init
{
    self = [super init];
    if(self){
        _currState = [[NJAIStateGeneral alloc] initWithOwner:self];
    }
    return self;
}


- (void) update
{
    if (_currState) {
        [_currState execute];
    }
}

- (void) changeToState:(NJAIStateType)newState
{
    switch (newState) {
        case GENERAL:
            _currState = [[NJAIStateGeneral alloc]initWithOwner:self];
            break;
        case WANDER:
            _currState = [[NJAIStateWander alloc]initWithOwner:self];
            break;
        case SURVIVAL:
            _currState = [[NJAIStateSurvival alloc]initWithOwner:self];
            break;
        case ARMED:
            _currState = [[NJAIStateArmed alloc]initWithOwner:self];
            break;
        default:
            break;
    }
}

@end

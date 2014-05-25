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
        _prevPileList = [NSMutableArray array];
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
    [_currState exit];
    switch (newState) {
        case GENERAL:
            _currState = [[NJAIStateGeneral alloc]initWithOwner:self];
            _currState.delegate = _delegate;
            NSLog(@"general state");
            break;
        case WANDER:
            _currState = [[NJAIStateWander alloc]initWithOwner:self];
            _currState.delegate = _delegate;
            NSLog(@"wander state");
            break;
        case SURVIVAL:
            _currState = [[NJAIStateSurvival alloc]initWithOwner:self];
            _currState.delegate = _delegate;
            NSLog(@"survival state");
            break;
        case ARMED:
            _currState = [[NJAIStateArmed alloc]initWithOwner:self];
            _currState.delegate = _delegate;
            NSLog(@"armed state");
            break;
        default:
            break;
    }
    [_currState enter];
}

@end

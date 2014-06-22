//
//  NJAIPlayer.m
//  NinjaJump
//
//  Created by wulifu on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIPlayer.h"
#import "NJAIStateAggressive.h"
#import "NJAIStateGeneral.h"
#import "NJAIStateSurvival.h"
#import "NJAIStateWander.h"

@interface NJAIPlayer()

@property int count;

@end

@implementation NJAIPlayer

- (id) init
{
    self = [super init];
    if(self){
        _currState = [[NJAIStateGeneral alloc] initWithOwner:self];
        _prevPileList = [NSMutableArray array];
        _count = 0;
    }
    return self;
}


- (void) update
{
    if (_currState) {
        if (_count==0) {
            [_currState execute];
        }
       _count =  (_count+1)%kAIOperationInterval;
    }
}

- (void) changeToState:(NJAIStateType)newState
{
    [_currState exit];
    switch (newState) {
        case GENERAL:
            _currState = [[NJAIStateGeneral alloc]initWithOwner:self];
            _currStateType = GENERAL;
            _currState.delegate = _delegate;
            //NSLog(@"general state");
            break;
        case WANDER:
            _currState = [[NJAIStateWander alloc]initWithOwner:self];
            _currStateType = WANDER;
            _currState.delegate = _delegate;
            //NSLog(@"wander state");
            break;
        case SURVIVAL:
            _currState = [[NJAIStateSurvival alloc]initWithOwner:self];
            _currStateType = SURVIVAL;
            _currState.delegate = _delegate;
            //NSLog(@"survival state");
            break;
        case AGGRESSIVE:
            _currState = [[NJAIStateAggressive alloc]initWithOwner:self];
            _currStateType = AGGRESSIVE;
            _currState.delegate = _delegate;
            //NSLog(@"aggressive state");
            break;
        default:
            break;
    }
    [_currState enter];
}

@end

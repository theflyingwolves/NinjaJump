//
//  NJAIPlayer.h
//  NinjaJump
//
//  Created by wulifu on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPlayer.h"
#import "NJAIState.h"
#import "NJMultiplayerLayeredCharacterScene.h"

typedef enum {GENERAL, WANDER, SURVIVAL, ARMED} NJAIStateType;


@interface NJAIPlayer : NJPlayer

@property id<NJAIDelegate> delegate;
@property NJAIState *currState;
@property NSMutableArray *prevPileList;
@property NJAIStateType currStateType;

- (void) update;

- (void) changeToState:(NJAIStateType)newState;

@end

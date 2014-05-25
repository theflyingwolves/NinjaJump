//
//  NJAIState.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJAIState.h"

@implementation NJAIState

@synthesize owner;

- (id)initWithOwner:(NJAIPlayer *)player
{
    self = [super init];
    if(self){
        owner = player;
    }
    return self;
}

- (void)enter
{
    
}

- (void)execute
{
    
}

- (void)exit
{
    
}

@end

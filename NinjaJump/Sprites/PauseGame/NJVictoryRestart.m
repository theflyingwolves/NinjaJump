//
//  NJVictoryRestart.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 19/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJVictoryRestart.h"

@implementation NJVictoryRestart

- (id)init
{
    self = [super init];
    if (self) {
        [self.resumeBtn removeFromParent];
        [self removeChildrenInArray:[NSArray arrayWithObject:self.resumeBtn]];
        self.homeBtn.position = CGPointMake(0, 80);
        self.restartBtn.position = CGPointMake(0, -80);
    }
    return self;
}
@end

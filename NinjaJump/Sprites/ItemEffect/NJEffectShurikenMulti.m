//
//  NJEffectShurikenMulti.m
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJEffectShurikenMulti.h"
#import "NJGraphicsUnitilities.h"

#define kShurikenEffectFileName @"shuriken.png"

@implementation NJEffectShurikenMulti

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction;{
    self = [super initWithTextureNamed:kShurikenEffectFileName atPosition:position];
    if (self) {
        _direction = direction;
    }
    return self;
}

// EFFECTS: Update the next-frame renderring of the pile
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval{
    self.position = PositionAfterMovement(self.position, self.direction, self.speed);
}

@end

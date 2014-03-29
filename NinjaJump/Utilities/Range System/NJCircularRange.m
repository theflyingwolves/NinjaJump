//
//  NJCircularRange.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJCircularRange.h"

@implementation NJCircularRange
- (BOOL)isPointWithinRange:(CGPoint)point
{
    double distance = hypotf(point.x-self.origin.x, point.y - self.origin.y);
    if (distance <= self.farDist && distance != 0) {
        return YES;
    }else{
        return NO;
    }
}
@end
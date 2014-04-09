//
//  NJRectangularRange.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJRectangularRange.h"

@implementation NJRectangularRange
- (BOOL)isPointWithinRange:(CGPoint)point
{
    double x = point.x - self.origin.x;
    double y = point.y - self.origin.y;
    double direction = self.facingDir;
    double updatedX = x*cos(direction) + y * sin(direction);
    double updatedY = -x*sin(direction) + y * sin(direction);
    
    double distance = hypotf(point.x-self.origin.x, point.y - self.origin.y);
    
    if (distance > 0.5f) {
        if (updatedX >= 0) {
            if (updatedY <= self.farDist && updatedY >= -self.farDist) {
                return YES;
            }
        }
    }

    return NO;
}

@end

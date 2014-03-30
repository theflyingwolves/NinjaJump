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
    double sineTheta = sinf(self.facingDir);
    double cosineTheta = cosf(self.facingDir);
    
    if (point.x * cosineTheta >= - point.y * sineTheta) {
        if (point.x*sineTheta + self.farDist >= point.y * cosineTheta &&
            point.x * sineTheta <= point.y * cosineTheta + self.farDist) {
            return YES;
        }
    }
    
    return NO;
}

@end

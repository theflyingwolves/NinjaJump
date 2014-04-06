//
//  NJFanRange.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJFanRange.h"

#define ANGULAR_TOLERANCE M_PI/3

@implementation NJFanRange

- (BOOL)isPointWithinRange:(CGPoint)point
{
    double angle = arctan(point.x - self.origin.x, point.y - self.origin.y);
    double distance = hypotf(point.x-self.origin.x, point.y - self.origin.y);
    if (distance <= self.farDist && distance >= 0.5) {
        NSLog(@"within distance");
        if (angle <= self.facingDir + ANGULAR_TOLERANCE && angle >= self.facingDir - ANGULAR_TOLERANCE) {
            NSLog(@"within angle");
            return YES;
        }
    }
    return NO;
}

double arctan(double x, double y)
{
    double angle = atanf(y/x);
    if (angle < 0 && x > 0) {
        angle += 2*M_PI;
    }else if(angle < 0 && x < 0){
        angle += M_PI;
    }else if(angle > 0 && x < 0){
        angle += M_PI;
    }
    return angle;
}
@end
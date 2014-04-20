//
//  NJRange.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
 Defines an abstract data type used by special items to indicate their corresponding range of effect. It also provides an API that checks if a given point is within the range defined.
 */
#import "NJRange.h"

@implementation NJRange

- (NJRange *)initWithOrigin:(CGPoint)origin farDist:(double)dist andFacingDir:(double)dir
{
    self = [super init];
    if (self) {
        _origin = origin;
        _farDist = dist;
        _facingDir = dir;
    }
    return self;
}

- (BOOL)isPointWithinRange:(CGPoint)point
{
    // Overriden by subclasses
    return NO;
}

@end
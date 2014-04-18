//
//  NJRange.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//
/*
 NJRange defines a 2D range in the game board. It also provides an interface that allows the check of whether a given point is within the range or not.
 */

#import <SpriteKit/SpriteKit.h>

@interface NJRange : NSObject
@property CGPoint origin;
@property double farDist;
@property double facingDir;

// EFFECTS: Initialize the range in the game board
- (NJRange *)initWithOrigin:(CGPoint)origin farDist:(double)dist andFacingDir:(double)dir;

// EFFECTS: Checks whether a given point is within the range defined by the classes
- (BOOL)isPointWithinRange:(CGPoint)point;
@end
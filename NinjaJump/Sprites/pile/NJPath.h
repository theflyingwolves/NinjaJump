//
//  NJPath.h
//  NinjaJump
//
//  Created by wulifu on 19/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJPath : NSObject

typedef enum : uint8_t {
   linear = 0
} NJPathMoveMode;


- (instancetype) initPathWithPoints:(NSArray*)points andMode:(NSArray*)modes;
//REQUIRES: points is an array of NSValue(CGPoint) which has at least 2 points
//          modes is an array of NSNumber (NJPathMoveMode) correspond to the points
//          note that length of modes = length of points - 1

// EFFECTS: return the state of the pile on this path afte a timeInterval
- (NSDictionary*)stateAfterTimeInterval:(CFTimeInterval)interval withSpeed:(float)speed;

// EFFECTS: return the state of the pile on this path afte a timeInterval
// MODIFIES: self
- (NSDictionary*)updateStateAfterTimeInterval:(CFTimeInterval)interval withSpeed:(float)speed;

@end

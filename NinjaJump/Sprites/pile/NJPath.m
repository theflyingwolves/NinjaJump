//
//  NJPath.m
//  NinjaJump
//
//  Created by wulifu on 19/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPath.h"

@implementation NJPath{
    NSArray *keyPoints;
    NSArray *keyModes;
    NSInteger curIndex;
    CGPoint curPosition;
    BOOL moveReverse;
    
    BOOL simulating;
    NSInteger curIndexSimulated;
    CGPoint curPositionSimulated;
    BOOL moveReverseSimulated;
    
}


- (instancetype) initPathWithPoints:(NSArray*)points andMode:(NSArray*)modes{
    self = [super init];
    
    if (self) {
        keyPoints = points;
        keyModes = modes;
        curIndex = 0;
        curPosition = [((NSValue*)points[0]) CGPointValue];
        moveReverse = NO;
        simulating = NO;
    }
    
    return self;
}

- (NSDictionary*)updateStateAfterTimeInterval:(CFTimeInterval)interval withSpeed:(float)speed{
    NSDictionary *state = [self stateAfterTimeInterval:interval withSpeed:speed];
    curIndex = [((NSNumber*)state[@"index"]) integerValue];
    curPosition = [((NSValue*)state[@"position"]) CGPointValue];
    moveReverse = [((NSNumber*)state[@"moveReverse"]) boolValue];
    
    return state;
}

// EFFECTS: return the position of the pile on this path afte a timeinterval
- (NSDictionary*)stateAfterTimeInterval:(CFTimeInterval)interval withSpeed:(float)speed{
    
    if (interval <= 0) {
        simulating = NO;
        NSMutableDictionary *state = [NSMutableDictionary dictionary];
        state[@"position"] = [NSValue valueWithCGPoint:curPositionSimulated];
        state[@"index"] = [NSNumber numberWithInteger:curIndexSimulated];
        state[@"moveReverse"] = [NSNumber numberWithBool:moveReverseSimulated];
        
        return state;
    } else {
        if (!simulating) {
            simulating = YES;
            curIndexSimulated = curIndex;
            curPositionSimulated = curPosition;
            moveReverseSimulated = moveReverse;
        }
        
        float time = [self timeNeededToFinishMovement:curIndexSimulated fromPosition:curPositionSimulated withDirectionIsReverse:moveReverseSimulated andSpeed:speed];
        if (time <= interval) {
            if (!moveReverseSimulated) {
                if (curIndexSimulated < [keyModes count] - 1) {
                    curIndexSimulated++;
                    curPositionSimulated = [(NSValue*)keyPoints[curIndexSimulated] CGPointValue];
                } else {
                    moveReverseSimulated = YES;
                    curPositionSimulated = [(NSValue*)keyPoints[curIndexSimulated+1] CGPointValue];
                }
            } else {
                if (curIndexSimulated > 0) {
                    curIndexSimulated--;
                    curPositionSimulated = [(NSValue*)keyPoints[curIndexSimulated+1] CGPointValue];
                } else {
                    moveReverseSimulated = NO;
                    curPositionSimulated = [(NSValue*)keyPoints[curIndexSimulated] CGPointValue];
                }
            }
            return [self stateAfterTimeInterval:(interval-time) withSpeed:speed];
        } else {
            simulating = NO;
            curPositionSimulated = [self getPositionAfterMovement:curIndexSimulated fromPosition:curPositionSimulated withDirectionIsReverse:moveReverseSimulated andSpeed:speed andTime:interval];
            NSNumber *finalIndex = [NSNumber numberWithInteger:curIndexSimulated];
            NSValue *finalPosition = [NSValue valueWithCGPoint:curPositionSimulated];
            NSNumber *finalIsReverse = [NSNumber numberWithBool:moveReverseSimulated];
            
            NSDictionary *state = [NSDictionary dictionaryWithObjects:@[finalIndex, finalPosition, finalIsReverse] forKeys:@[@"index", @"position", @"moveReverse"]];
            return state;
        }
    }
}

- (float) timeNeededToFinishMovement:(NSInteger)movementIndex fromPosition:(CGPoint)position withDirectionIsReverse:(BOOL)isReverse andSpeed:(float)speed{
    CGPoint targetPos;
    if (isReverse) {
        targetPos = [(NSValue*)(keyPoints[movementIndex]) CGPointValue];;
    } else{
        targetPos = [(NSValue*)(keyPoints[movementIndex+1]) CGPointValue];;
    }
    
    float time ;
    float distance;
    NJPathMoveMode mode = (NJPathMoveMode)([keyModes[movementIndex] integerValue]);
    switch (mode) {
        case linear:
            distance = sqrtf(powf(position.x-targetPos.x, 2) + powf(position.y - targetPos.y, 2));
            time = distance/speed;
            break;
            
        default:
            break;
    }
    
    
    return time;
}

- (CGPoint) getPositionAfterMovement:(NSInteger)movementIndex fromPosition:(CGPoint)position withDirectionIsReverse:(BOOL)isReverse andSpeed:(float)speed andTime:(float)time{
    CGPoint movementStart;
    CGPoint movementEnd;
    CGPoint newPosition;
    
    if (!isReverse){
        movementStart =[(NSValue*)(keyPoints[movementIndex]) CGPointValue];
        movementEnd =[(NSValue*)(keyPoints[movementIndex+1]) CGPointValue];
    } else{
        movementStart =[(NSValue*)(keyPoints[movementIndex+1]) CGPointValue];
        movementEnd =[(NSValue*)(keyPoints[movementIndex]) CGPointValue];
    }
    
    NJPathMoveMode mode = (NJPathMoveMode)([keyModes[movementIndex] integerValue]);
    switch (mode) {
        case linear:
            newPosition = [self getPositionAfterLinearMovementFromPosition:position withMovementStartPoint:movementStart andMovementEndPoint:movementEnd andSpeed:speed andTime:time];
            break;
            
        default:
            break;
    }
    

    
    return newPosition;
}

- (CGPoint) getPositionAfterLinearMovementFromPosition:(CGPoint)position withMovementStartPoint:(CGPoint)start andMovementEndPoint:(CGPoint)end andSpeed:(float)speed andTime:(float)time{
    CGVector realSpeed = CGVectorMake(end.x-start.x, end.y-start.y);
    float speedAmountTemp = sqrtf(powf(realSpeed.dx, 2) + powf(realSpeed.dy, 2));
    CGVector realSpeedNormalized = CGVectorMake(realSpeed.dx/speedAmountTemp, realSpeed.dy/speedAmountTemp);
    realSpeed = CGVectorMake(speed * realSpeedNormalized.dx, speed * realSpeedNormalized.dy);
    return CGPointMake(position.x + realSpeed.dx * time, position.y + realSpeed.dy * time);
}

@end



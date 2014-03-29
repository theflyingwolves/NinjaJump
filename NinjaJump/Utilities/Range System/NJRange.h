//
//  NJRange.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NJRange : NSObject
@property CGPoint origin;
@property double farDist;
@property double facingDir;

- (NJRange *)initWithOrigin:(CGPoint)origin farDist:(double)dist andFacingDir:(double)dir;
- (BOOL)isPointWithinRange:(CGPoint)point;
@end
//
//  NJGraphicsUnitilities.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJGraphicsUnitilities.h"

@implementation NJGraphicsUnitilities

+ (NSArray *)NJLoadFramesFromAtlas:(NSString *)atlasName withBaseName:(NSString *)baseName andNumOfFrames:(int)numOfFrames

{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numOfFrames];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    for (int i = 1; i <= numOfFrames; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%03d.png", baseName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [frames addObject:texture];
    }
    
    return frames;
}

CGFloat NJRadiansBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return atan2f(deltaY, deltaX);
}

CGFloat NJDistanceBetweenPoints(CGPoint first, CGPoint second)
{
    CGFloat dx = second.x - first.x;
    CGFloat dy = second.y - second.y;
    return hypotf(dx, dy);
}

CGPoint PositionAfterMovement(CGPoint from, CGFloat radians, CGFloat distance){
    CGFloat dx = distance * cos(radians);
    CGFloat dy = distance * sin(radians);
    
    return CGPointMake(from.x+dx, from.y+dy);
}

CGVector vectorForMovement(CGFloat radians, CGFloat distance){
    CGFloat dx = distance * cos(radians);
    CGFloat dy = distance * sin(radians);
    
    return CGVectorMake(dx, dy);
}

CGFloat normalizeZRotation(CGFloat zRotation){
    if (zRotation > M_PI) {
        float diff = 2*M_PI - zRotation;
        return (0-diff);
    } else {
        return zRotation;
    }
}

bool CGPointEqualToPointApprox(CGPoint point1, CGPoint point2){
    if ((int)point1.x*100 == (int)point2.x*100 && (int)point1.y*100 == (int)point2.y*100) {
        return YES;
    } else {
        return NO;
    }
}

CGPoint CGPointApprox(CGPoint point){
    float x = ((int)point.x*100)/100.0;
    float y = ((int)point.y*100)/100.0;
    return CGPointMake(x, y);
}

CGFloat NJRandomAngle()
{
    CGFloat ang = (arc4random()%11)/10.0*2*M_PI-M_PI;
    return ang;
}

@end

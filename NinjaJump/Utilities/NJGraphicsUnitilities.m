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

CGPoint PositionAfterMovement(CGPoint from, CGFloat radians, CGFloat speed){
    CGFloat dx = speed * cos(radians);
    CGFloat dy = speed * sin(radians);
    
    return CGPointMake(from.x+dx, from.y+dy);
}
@end

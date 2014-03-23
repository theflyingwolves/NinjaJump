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
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", baseName, i];
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
@end

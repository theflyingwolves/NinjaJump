//
//  NJGraphicsUnitilities.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


#define NJ_POLAR_ADJUST(x) x + (M_PI * 0.5f)

@interface NJGraphicsUnitilities : NSObject

+ (NSArray *)NJLoadFramesFromAtlas:(NSString *)atlasName withBaseName:(NSString *)baseName andNumOfFrames:(int)numOfFrames;
CGFloat NJRadiansBetweenPoints(CGPoint first, CGPoint second);
@end

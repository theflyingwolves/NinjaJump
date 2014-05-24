//
//  NJGameAttribute.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "NJConstants.h"

@interface NJGameAttribute : NSObject
@property NJGameMode mode;

+ (id)attributeWithMode:(NJGameMode)mode;
- (int)getNumberOfFramesToSpawnItem;
- (SKSpriteNode *)getVictoryLabelForWinnerIndex:(NSInteger)index;
- (BOOL)shouldApplyImpulesToSlowWoodpiles;
- (BOOL)shouldWoodpileMove;
@end

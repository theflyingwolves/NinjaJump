//
//  NJScroll.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSpecialItem.h"

@class NJRange,NJScroll;

@protocol NJScrollDelegate <NSObject>
- (NSArray *)getAffectedTargetsWithRange:(NJRange *)range;
- (void)applyGlobalScrollAnimationForScroll:(NJScroll *)scroll;
@end

@interface NJScroll : NJSpecialItem
@property id<NJScrollDelegate> delegate;

- (id)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate;
@end
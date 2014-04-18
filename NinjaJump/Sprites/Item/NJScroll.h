//
//  NJScroll.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    This class subclass NJSpecialItem, it is the parent of all scrolls in the game
*/

#import "NJSpecialItem.h"

@class NJRange,NJScroll;

@protocol NJScrollDelegate <NSObject>
- (NSArray *)getAffectedTargetsWithRange:(NJRange *)range;
- (NSArray *)getAffectedPilesWithRange:(NJRange *)range;
@end

@interface NJScroll : NJSpecialItem
@property id<NJScrollDelegate> delegate;

- (id)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate;

- (void)fireAttackedAnimation:(NJCharacter *)character;

@end
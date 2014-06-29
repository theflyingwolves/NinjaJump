//
//  NJAIState.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJPile.h"
#import "NJGraphicsUnitilities.h"
#import "NJNinjaCharacter.h"
#import "NJMine.h"
#import "NJScroll.h"
#import "NJShuriken.h"

@protocol NJAIDelegate <NSObject>

- (BOOL)containsPile:(NJPile *)pile;

- (NJPile *)woodPileToJump:(NJCharacter *)ninja;

- (NSArray *)getAllPlayers;

- (NJCharacter *)getNearestCharacter:(NJCharacter *)ninja;

- (BOOL)isPileTargeted:(NJPile *)pile;

@end

@class NJAIPlayer;

@interface NJAIState : NSObject

@property (nonatomic, weak) id<NJAIDelegate> delegate;
@property(nonatomic) NJAIPlayer *owner;
@property (nonatomic) BOOL jumpFlag;
@property (nonatomic) CGFloat alertDist;
@property (nonatomic) Class targetItemClass;

- (id)initWithOwner:(NJAIPlayer *)player;

- (void)enter;

- (void)execute;

- (void)exit;

- (void)jumpWithFrequency:(CGFloat)frequency;

- (void)changeState;

- (void)useItemWithinRadius:(CGFloat) attackRadius;

@end

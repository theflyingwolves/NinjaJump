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

@protocol NJAIDelegate <NSObject>

- (BOOL)containsPile:(NJPile *)pile;

- (NJPile *)woodPileToJump:(NJCharacter *)ninja;

- (NJCharacter *)getNearestCharacter:(NJCharacter *)ninja;

@end

@class NJAIPlayer;

@interface NJAIState : NSObject

@property (nonatomic, weak) id<NJAIDelegate> delegate;
@property(nonatomic) NJAIPlayer *owner;
@property (nonatomic) BOOL jumpFlag;

- (id)initWithOwner:(NJAIPlayer *)player;

- (void)enter;

- (void)execute;

- (void)exit;

- (void)jumpWithFrequency:(CGFloat)frequency and:(BOOL)isWander;

- (void)changeState;

- (void)useItemWithDistance:(CGFloat)distance;


@end

//
//  NJAIState.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJAIPlayer.h"



@protocol NJAIDelegate <NSObject>

- (NJPile *) woodPileToJump:(NJCharacter *)character;

@end

@interface NJAIState : NSObject

@property (nonatomic, weak) id<NJAIDelegate> delegate;
@property(nonatomic) NJAIPlayer *owner;

- (id)initWithOwner:(NJAIPlayer *)player;

- (void)enter;

- (void)execute;

- (void)exit;

@end

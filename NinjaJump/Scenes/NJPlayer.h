//
//  NJPlayer.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJSpecialItem.h"

@class NJNinjaCharacter, SKColor, NJPile;

@interface NJPlayer : NSObject
@property (nonatomic) NJNinjaCharacter *ninja;
@property (nonatomic) SKColor *color;

@property (nonatomic) BOOL isDisabled;
@property (nonatomic) BOOL fireAction;

@property (nonatomic) NJPile *fromPile;
@property (nonatomic) NJPile *targetPile;
@property (nonatomic) BOOL isJumping;

@property (nonatomic) BOOL jumpRequested;               // used to track whether a move was requested

@property (nonatomic) NJSpecialItem *item;

@property (nonatomic) BOOL itemUseRequested;

@end
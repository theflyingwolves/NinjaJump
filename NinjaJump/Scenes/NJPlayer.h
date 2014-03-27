//
//  NJPlayer.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJSpecialItem.h"

@class NJNinjaCharacter, SKColor;

@interface NJPlayer : NSObject
@property (nonatomic) NJNinjaCharacter *ninja;
@property (nonatomic) SKColor *color;

@property (nonatomic) BOOL isActive;

@property (nonatomic) CGPoint spawnPoint;
@property (nonatomic) BOOL fireAction;

@property (nonatomic) CGPoint startLocation;
@property (nonatomic) CGPoint targetLocation;
@property (nonatomic) BOOL isJumping;

@property (nonatomic) BOOL jumpRequested;               // used to track whether a move was requested

@property (nonatomic) NJSpecialItem *item;

@property (nonatomic) BOOL itemUseRequested;

@end
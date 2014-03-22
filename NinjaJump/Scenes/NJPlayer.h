//
//  NJPlayer.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NJNinjaCharacter;

@interface NJPlayer : NSObject
@property (nonatomic) NJNinjaCharacter *ninja;

@property (nonatomic) CGPoint spawnPoint;
@property (nonatomic) BOOL fireAction;

@property (nonatomic) CGPoint targetLocation;

@property (nonatomic) BOOL jumpRequested;               // used to track whether a move was requested

@end

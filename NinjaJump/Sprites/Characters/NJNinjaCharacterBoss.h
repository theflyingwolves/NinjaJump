//
//  NJNinjaCharacterBoss.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJNinjaCharacter.h"

@interface NJNinjaCharacterBoss : NJNinjaCharacter

@property (nonatomic) BOOL needsAddItem;
@property (nonatomic) NSTimeInterval addItemTimer;

@end

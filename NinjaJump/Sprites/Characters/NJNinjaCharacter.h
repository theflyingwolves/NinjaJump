//
//  NJNinjaCharacter.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJCharacter.h"

@class NJPlayer;

@interface NJNinjaCharacter : NJCharacter
//@property (nonatomic, weak) NJPlayer *player;

- (id)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player;
@end

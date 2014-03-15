//
//  NJCharacter.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJCharacter.h"

@implementation NJCharacter

+(instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    return (NJCharacter *)[SKSpriteNode spriteNodeWithImageNamed:name];
}

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position
{
    self = [NJCharacter spriteNodeWithImageNamed:textureName];
    if (self) {
        self.position = position;
    }
    
    return self;
}


@end
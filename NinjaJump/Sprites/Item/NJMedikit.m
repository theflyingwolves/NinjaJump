//
//  NJMedikit.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMedikit.h"
#define kSoundRecover @"recover.mid"

@implementation NJMedikit

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemMedikit;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
<<<<<<< HEAD
    //[self runAction:[SKAction playSoundFileNamed:kSoundRecover waitForCompletion:NO]];
=======
//    [self runAction:[SKAction playSoundFileNamed:kSoundRecover waitForCompletion:NO]];
>>>>>>> 1d37fd9421f86ace1fca3de3c9fb8cc350ffe558
}

@end

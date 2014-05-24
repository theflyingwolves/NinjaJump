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

+(instancetype)itemAtPosition:(CGPoint)position
{
    return [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
}

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemMedikit;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    [self runAction:[SKAction playSoundFileNamed:kSoundRecover waitForCompletion:NO]];
}

@end

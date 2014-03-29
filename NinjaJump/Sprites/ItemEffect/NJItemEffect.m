//
//  NJItemEffect.m
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJItemEffect.h"

@implementation NJItemEffect

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position onScene:(NJMultiplayerLayeredCharacterScene*)scene{
    self = [super initWithImageNamed:textureName];
    if (self) {
        self.position = position;
        [self configurePhysicsBody];
        [scene addNode:self atWorldLayer:NJWorldLayerCharacter];
    }
    return self;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    // Overridden by subclasses to create a physics body with relevant collision settings for this effect.
}

@end

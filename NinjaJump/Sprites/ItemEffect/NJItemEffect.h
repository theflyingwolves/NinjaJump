//
//  NJItemEffect.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJMultiplayerLayeredCharacterScene.h"

@interface NJItemEffect : SKSpriteNode{
@protected NSInteger _damage;
}

@property (readonly) NSInteger damage;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position onScene:(NJMultiplayerLayeredCharacterScene*)scene;


//methods to be overriden
- (void)configurePhysicsBody;

@end

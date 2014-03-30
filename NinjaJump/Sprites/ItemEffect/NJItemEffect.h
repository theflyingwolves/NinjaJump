//
//  NJItemEffect.h
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJCharacter.h"

@interface NJItemEffect : SKSpriteNode{
@protected NSInteger _damage;
}

@property (readonly) NSInteger damage;
@property (readonly, nonatomic, weak) NJCharacter *owner;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner;


//methods to be overriden
- (void)configurePhysicsBody;

@end

//
//  NJEffectMine.m
//  NinjaJump
//
//  Created by wulifu on 30/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJEffectMine.h"
#import "NJMine.h"
#import "NJPile.h"
#import "NJMultiPlayerLayeredCharacterScene.h"
#import "NJConstants.h"

#define kMineEffectInvisible @"mineEffectInvisible.png"
#define kMineDamage 20

@implementation NJEffectMine

- (void)performEffect {
    NJMine *mineTexture = [[NJMine alloc]initWithTextureNamed:kMineFileName atPosition:CGPointMake(0, 0) ];
    [self addChild:mineTexture];
    [self runAction:[SKAction moveBy:CGVectorMake(0, 0) duration:1] completion:^{[mineTexture removeFromParent];}];
}

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner{
    self = [super initWithTextureNamed:kMineEffectInvisible atPosition:position onScene:scene andOwner:owner];
    if (self) {
        _damage = kMineDamage;
        
        for (NJPile *pile in scene.woodPiles){
            if (hypotf(owner.position.x-pile.position.x, owner.position.y-pile.position.y)<=CGRectGetWidth(pile.frame)/2){
                pile.itemEffectOnPile = self;
                _pile = pile;
            }
        }
        
        [self performEffect];
    }
    return self;
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    
    // Our object type for collisions.
    self.physicsBody.categoryBitMask = NJColliderTypeItemEffectMine;
    
    // Collides with these objects.
    //    self.physicsBody.collisionBitMask = NJColliderTypeCharacter;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = NJColliderTypeCharacter;
}

@end

//
//  NJEffectMine.m
//  NinjaJump
//
//  Created by wulifu on 30/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJEffectMine.h"
#import "NJMine.h"

#define kMineEffectInvisible @"mineEffectInvisible.png"
#define kMineFileName @"mine.png"
#define kMineDamage 20

@implementation NJEffectMine

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner{
    self = [super initWithTextureNamed:kMineEffectInvisible atPosition:position onScene:scene andOwner:owner];
    if (self) {
        _damage = kMineDamage;
        NJMine *mineTexture = [[NJMine alloc]initWithTextureNamed:kMineFileName atPosition:CGPointMake(0, 0) ];
        [self addChild:mineTexture];
//        SKAction *wait = [SKAction waitForDuration:1];
//        SKAction *removeNode = [SKAction removeFromParent];
//        SKAction *sequence = [SKAction sequence:@[wait,removeNode]];
//        [mineTexture runAction:sequence];
    }
    return self;
}


#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    
    // Our object type for collisions.
    self.physicsBody.categoryBitMask = NJColliderTypeItemEffect;
    
    // Collides with these objects.
    //    self.physicsBody.collisionBitMask = NJColliderTypeCharacter;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = NJColliderTypeCharacter;
}

@end

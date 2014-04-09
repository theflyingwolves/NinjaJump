//
//  NJEffectShurikenMulti.m
//  NinjaJump
//
//  Created by wulifu on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJEffectShurikenMulti.h"
#import "NJGraphicsUnitilities.h"

#define kShurikenEffectFileName @"shurikenEffect.png"
#define kShurikenSpeed 800
#define kShurikenMaxDistance 1500
#define kShurikenMultiDamage 20
@implementation NJEffectShurikenMulti

-(instancetype)initAtPosition:(CGPoint)position withDirection:(CGFloat)direction onScene:(NJMultiplayerLayeredCharacterScene*)scene andOwner:(NJCharacter*)owner{
    self = [super initWithTextureNamed:kShurikenEffectFileName atPosition:position onScene:scene andOwner:owner];
    if (self) {
        _direction = direction;
        _damage = kShurikenMultiDamage;
    }
    return self;
}

- (void)fireShuriken
{
    CGVector movement = vectorForMovement(_direction, kShurikenMaxDistance);
    [self runAction:[SKAction moveByX:movement.dx y:movement.dy duration:kShurikenMaxDistance/kShurikenSpeed] completion:^{[self removeFromParent];}];
}

#pragma mark - Overridden Methods
- (void)configurePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    
    // Our object type for collisions.
    self.physicsBody.categoryBitMask = NJColliderTypeItemEffectShuriken;
    
    // Collides with these objects.
    self.physicsBody.collisionBitMask = 0;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = NJColliderTypeCharacter;
}

@end

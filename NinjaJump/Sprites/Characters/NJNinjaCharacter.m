//
//  NJNinjaCharacter.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 18/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJNinjaCharacter.h"
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"
#import "NJItemEffect.h"
#import "NJEffectMine.h"
#import "NJPile.h"

#define kSoundBomb @"hurt.mid"
#define kSoundShuriken @"hurt.mid"

@implementation NJNinjaCharacter

const CGFloat medikitRecover = 40.0f;

- (instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withPlayer:(NJPlayer *)player
{
    self = [super initWithTextureNamed:textureName AtPosition:position];
    
    if (self) {
        self.player = player;
    }
    
    return self;
}

#pragma mark - Pickup Item
- (void)pickupItem:(NSArray *)items onPile:(NJPile *)pile{
    for (NJSpecialItem *item in items) {
        if (hypotf(self.position.x-item.position.x, self.position.y-item.position.y)<=CGRectGetWidth(pile.frame)/2) {
            
            item.isPickedUp = YES;
            
            pile.itemHolded = nil;
            [item removeFromParent];
//            NSLog(@"picked up item: %@",self.player.item);
            
            switch (item.itemType) {
                case NJItemMedikit:
                    [self recover:medikitRecover];
                    [item useAtPosition:self.position withDirection:0 byCharacter:self];
                    break;
                
                default:
                    self.player.item = item;
                    break;
            }
        }
    }
}

#pragma mark - Use Items
- (void)useItem:(NJSpecialItem *)item
{
    CGFloat direction = self.zRotation;
    if (direction >= 0 && direction <= M_PI) {
        direction += M_PI / 2;
    }else if(direction <= 0 && direction >= - M_PI / 2){
        direction += M_PI / 2;
    }else if(direction <= -M_PI / 2 && direction >= - M_PI){
        direction += 5 * M_PI / 2;
    }else{
        NSLog(@"useItem: zRotation Detection Error");
    }
    
    NSLog(@"direction: %f",direction);
    [item useAtPosition:self.position withDirection:direction byCharacter:self];
    self.player.item = nil;
}

#pragma mark - physics
- (void)collidedWith:(SKPhysicsBody *)other{
    [super collidedWith:other];
    if (other.categoryBitMask & NJColliderTypeItemEffectShuriken) {
        NJItemEffect *effect =(NJItemEffect*)other.node;
        if (effect.owner != self) {
            [self applyDamage:effect.damage];
            [effect removeAllActions];
            [effect removeFromParent];
            [self runAction:[SKAction playSoundFileNamed:kSoundShuriken waitForCompletion:NO]];
        }
    } else if (other.categoryBitMask & NJColliderTypeItemEffectMine) {
        NJEffectMine *effect =(NJEffectMine*)other.node;
        if (effect.owner != self && effect.pile.standingCharacter == self) {
            [self applyDamage:effect.damage];
            [effect removeAllActions];
            [effect removeFromParent];
            effect.pile.itemEffectOnPile = nil;
            [self runAction:[SKAction playSoundFileNamed:kSoundBomb waitForCompletion:NO]];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bomb" ofType:@"sks"];
            SKEmitterNode *bombEffect = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            [self addChild:bombEffect];
            SKAction *wait = [SKAction waitForDuration:0.5];
            SKAction *removeNode = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[wait, removeNode]];
            [bombEffect runAction:sequence];
        }
    }
}

-(void)configurePhysicsBody{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = NJColliderTypeCharacter;
    
    // Collides with these objects.
//    self.physicsBody.collisionBitMask = NJColliderTypeItemEffect;
    
    // We want notifications for colliding with these objects.
    self.physicsBody.contactTestBitMask = NJColliderTypeItemEffectShuriken | NJColliderTypeItemEffectMine;

    self.physicsBody.dynamic = NO;
//    self.physicsBody.linearDamping = 0.0f;
    
}

@end

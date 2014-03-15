//
//  NJCharacter.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NJSpecialItem;

@interface NJCharacter : SKSpriteNode
+(void)loadSharedAssets;
-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position;

// Abstract Methods - to be implemented by subclasses

// EFFECTS: Reset the character back to initial states: Putting them back to starting position, removing all items possessed. However, the HP remains unchanged.
-(void)reset;

// EFFECTS:
-(void)animationDidComplete;
-(void)collideWith:(id)object;
-(void)performDeath;
-(void)configurePhysicsBody;

// EFFECTS: apply a given amount of damage to the character.
-(BOOL)applyDamage:(float)amount;

// EFFECTS: apply damage to the character according to the item causing the damage
-(BOOL)applyDamageFromItem:(NJSpecialItem *)item;

// EFFECTS: character jump to a given position
-(void)jumpToPosition:(CGPoint)position;

// EFFECTS: Only handle the animation of using the given item
-(void)useItem:(NJSpecialItem *)item;

// EFFECTS: Update the next-frame renderring of the character
-(BOOL)update;

@end

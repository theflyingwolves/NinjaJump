//
//  NJCharacter.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    NJCharacter is a SKSpriteNode representation of game characters. It is designed to be generic so as to cater to different kinds of characters in the game, so it has plenty of abstract methods (described below) to be overriden by subclasses.
 */

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    NJAnimationStateIdle = 0,
    NJAnimationStateJump,
    NJAnimationStateAttack,
    NJAnimationStateUseItem,
    NJAnimationStateGetHit,
    NJAnimationStateDeath,
    kAnimationStateCount
} NJAnimationState;

#import <SpriteKit/SpriteKit.h>

@class NJSpecialItem, NJMultiplayerLayeredCharacterScene, NJPlayer, NJPile, NJCharacter;

@protocol NJCharacterDelegate <NSObject>
- (void)addCharacter:(NJCharacter *)character;
// EFFECTS: Render characters to delegate (expected to be a SKScene)

- (void)addEffectNode:(SKSpriteNode *)effectNode;
// EFFECTS: Render the given effect node to the delegate (expected to be a SKScene)
@end

@interface NJCharacter : SKSpriteNode

#pragma mark - ability
@property NSInteger strength;
@property NSInteger intellect;
@property NSInteger vitality;
@property NSInteger agility;

#pragma mark - actual ability
@property (readonly) NSInteger physicalAttack;
@property (readonly) NSInteger physicalDefense;
@property (readonly) NSInteger hp;
@property (readonly) NSInteger magicAttack;
@property (readonly) NSInteger magicDefense;
@property (readonly) CGFloat JumpCoolTime;
@property (readonly) NSInteger jumpSpeed;

#pragma mark - Native Properties
@property (nonatomic) CGFloat health;
@property (nonatomic) SKTexture *origTexture;
@property (nonatomic) SKSpriteNode *shadow;
@property (nonatomic) float physicalDamageMultiplier;
@property (nonatomic) float magicalDamageMultiplier;
@property (nonatomic, weak) NJPlayer *player;
@property (nonatomic) CGPoint jumpTargetPosition;

#pragma mark - State Properties
@property (nonatomic, getter=isDying) BOOL dying;
@property (nonatomic, getter=isAttacking) BOOL attacking;
@property (nonatomic, getter=isAnimated) BOOL animated;

#pragma mark - Anmiation Properties
@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic) NSString *activeAnimationKey;
@property (nonatomic) NJAnimationState requestedAnimation;
@property float frozenCount;
@property SKSpriteNode *frozenEffect;

#pragma mark - Delegate
@property (nonatomic) id<NJCharacterDelegate> delegate;

#pragma mark - Initializer
+(void)loadSharedAssets;
// EFFECTS: load the assets common to all characters to memory for future use. Executed only once

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position delegate:(id<NJCharacterDelegate>)delegate;
// REQUIRES: Texture named textureName should have been added to the project, position should be within the rendering screen
// EFFECTS: Initialize a character with an initial texture and position

- (void)initActualAbility;
// REQUIRES: all Ability is well initialized for the specific characters
// EFFECTS: initialize the actual ability for a character based on the general ability

#pragma mark - Render
- (void)render;

#pragma mark - Reset
-(void)reset;
// EFFECTS: Reset the character back to initial states: Putting them back to starting position, removing all items possessed. However, the HP remains unchanged.

- (void)resetToPosition:(CGPoint)position;
// REQUIRES: position within the renderring screen
// MODIFIES: self.position
// EFFECTS: Respawn the character at the given position with respawn effects

#pragma mark - Animation
-(void)animationDidComplete;
// EFFECTS: Handle following animation after the jumping animation is complete, making ninja spin with the piles
// Abstract

- (NSArray *)jumpAnimationFrames;
// RETURNS: An array of frames for jumping animation
// Abstract

- (NSArray *)attackAnimationFrames;
// RETURNS: An array of frames for attack animation
// Abstract

- (NSArray *)thunderAnimationFrames;
//RETURNS: An array of frames for thunder animation
// Abstract

- (void)performThunderAnimation;
//EFFECTS: Perform the animation when the character use a thunder scroll

- (void)performWindAnimationInDirection:(CGFloat)direction;
//EFFECTS: Perform the animation when the character use a wind scroll

- (void)performFrozenEffect;
//REQUIRES: self != nil
//MODIFIES: self.frozenEffect, self.frozenCount
//EFFECTS: Perform the animation when being applied the effect freeze

#pragma mark - Update
- (void)updateAngularSpeed:(float) angularSpeed;
// EFFECTS: Update the angular speed for ninja's spinning when idle
// Abstract

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;
// EFFECTS: Update the next-frame rendering of the character

#pragma mark - Basic Operation
-(void)performDeath;
// EFFECTS: Remove ninja from game and Perform Death

-(BOOL)applyDamage:(CGFloat)amount;
// REQUIRES: amount >= 0
// MODIFIES: self.health
// EFFECTS: Apply a given amount of damage to the character.

- (BOOL)applyMagicalDamage:(CGFloat)damage;
// REQUIRES: amont >= 0
// MODIFIES: self.health
// EFFECTS: Apply the given amount of damage as magical damage to the character

- (BOOL)applyPhysicalDamage:(CGFloat)damage;
// REQUIRES: amont >= 0
// MODIFIES: self.health
// EFFECTS: Apply the given amount of damage as physical damage to the character

-(void)recover:(CGFloat)amount;
// REQUIRES: amount >=0
// MODIFIES: self.health
// EFFECTS:  Apply a given amount of recover to the character.

- (void)attackCharacter:(NJCharacter *)character;
// REQUIRES: character != nil
// MODIFIES: character.health, self.requestedAnimation
// EFFECTS:  Deduct the corresponding amount of health points from character and perform the corresponding attack animation

- (void)jumpToPile:(NJPile*)toPile fromPile:(NJPile*)fromPile withTimeInterval:(NSTimeInterval)timeInterval;
// EFFECTS: character jump to a given position
// MODIFIES: self.position, self.targetPile, self.fromPile

-(void)useItem:(NJSpecialItem *)item;
// EFFECTS: Handles the animation of using the given item

- (void)pickupItem:(NSArray *)items onPile:(NJPile *)pile;
// REQUIRES: items != nil, pile != nil, self != nil
// MODIFIES: self.itemHolded, item.isPickedup for each item in items, pile.itemHolded
// EFFECTS: Pick up the array of items given on a specific pile

#pragma mark - PhysicsBody
-(void)configurePhysicsBody;
// EFFECTS: Configure physics body to enable physics engine
// Abstract

- (void)collidedWith:(SKPhysicsBody *)other;
// REQUIRES: other != nil
// MODIFIES: self.health
// EFFECTS: Collision handler that specifies what are the actions to be performed when a collision occurs
// Abstract
@end

//
//  NJCharacter.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    NJCharacter is a SKSpriteNode representation of game characters. It is designed to be generic so as to cater to different kinds of characters in the game.
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

@class NJSpecialItem, NJMultiplayerLayeredCharacterScene, NJPlayer, NJPile;

@interface NJCharacter : SKSpriteNode
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

#pragma mark - Initializer
// EFFECTS: load the assets common to all characters to memory for future use. Executed only once
+(void)loadSharedAssets;

// REQUIRES: Texture named textureName should have been added to the project, position should be within the rendering screen
// EFFECTS: Initialize a character with an initial texture and position
-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position;

- (void)addToScene:(NJMultiplayerLayeredCharacterScene *)scene;

#pragma mark - Reset
// EFFECTS: Reset the character back to initial states: Putting them back to starting position, removing all items possessed. However, the HP remains unchanged.
-(void)reset;

// REQUIRES: position within the renderring screen
// MODIFIES: self.position
// EFFECTS: Respawn the character at the given position with respawn effects
- (void)resetToPosition:(CGPoint)position;

#pragma mark - Animation
// EFFECTS: Handle following animation after the jumping animation is complete, making ninja spin with the piles
-(void)animationDidComplete;

// RETURNS: An array of frames for jumping animation
- (NSArray *)jumpAnimationFrames;

// RETURNS: An array of frames for attack animation
- (NSArray *)attackAnimationFrames;

//RETURNS: An array of frames for thunder animation
- (NSArray *)thunderAnimationFrames;

//EFFECTS: Perform the animation when the character use the scroll
- (void)performThunderAnimationInScene:(NJMultiplayerLayeredCharacterScene*)scene;

- (void)performWindAnimationInScene:(NJMultiplayerLayeredCharacterScene *)scene direction:(CGFloat)direction;

//REQUIRES: self != nil
//MODIFIES: self.frozenEffect, self.frozenCount
//EFFECTS: Perform the animation when being applied the effect freeze
- (void)performFrozenEffect;

#pragma mark - Update
// EFFECTS: Update the angular speed for ninja's spinning when idle
- (void)updateAngularSpeed:(float) angularSpeed;

// EFFECTS: Update the next-frame rendering of the character
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

#pragma mark - Basic Operation
// EFFECTS: Remove ninja from game
-(void)performDeath;

// REQUIRES: amount >= 0
// MODIFIES: self.health
// EFFECTS: Apply a given amount of damage to the character.
-(BOOL)applyDamage:(CGFloat)amount;

// REQUIRES: amont >= 0
// MODIFIES: self.health
// EFFECTS: Apply the given amount of damage as magical damage to the character
- (BOOL)applyMagicalDamage:(CGFloat)damage;

// REQUIRES: amont >= 0
// MODIFIES: self.health
// EFFECTS: Apply the given amount of damage as physical damage to the character
- (BOOL)applyPhysicalDamage:(CGFloat)damage;

// REQUIRES: amount >=0
// MODIFIES: self.health
// EFFECTS:  Apply a given amount of recover to the character.
-(void)recover:(CGFloat)amount;

// REQUIRES: character != nil
// MODIFIES: character.health, self.requestedAnimation
// EFFECTS:  Deduct the corresponding amount of health points from character and perform the corresponding attack animation
- (void)attackCharacter:(NJCharacter *)character;

// EFFECTS: character jump to a given position
// MODIFIES: self.position, self.targetPile, self.fromPile
- (void)jumpToPile:(NJPile*)toPile fromPile:(NJPile*)fromPile withTimeInterval:(NSTimeInterval)timeInterval;

// EFFECTS: Handles the animation of using the given item
-(void)useItem:(NJSpecialItem *)item;

// REQUIRES: items != nil, pile != nil, self != nil
// MODIFIES: self.itemHolded, item.isPickedup for each item in items, pile.itemHolded
// EFFECTS: Pick up the array of items given on a specific pile
- (void)pickupItem:(NSArray *)items onPile:(NJPile *)pile;

#pragma mark - PhysicsBody
// EFFECTS: Configure physics body to enable physics engine
-(void)configurePhysicsBody;

// REQUIRES: other != nil
// MODIFIES: self.health
// EFFECTS: Collision handler that specifies what are the actions to be performed when a collision occurs
- (void)collidedWith:(SKPhysicsBody *)other;

@end

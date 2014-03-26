//
//  NJCharacter.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

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

@class NJSpecialItem, NJMultiplayerLayeredCharacterScene;

@interface NJCharacter : SKSpriteNode
@property (nonatomic, getter=isDying) BOOL dying;
@property (nonatomic, getter=isAttacking) BOOL attacking;

@property (nonatomic) CGFloat health;
@property (nonatomic) CGPoint jumpTargetPosition;
@property (nonatomic) CGPoint spawnPoint;

@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic) CGFloat movementSpeed;
@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic) NSString *activeAnimationKey;
@property (nonatomic) NJAnimationState requestedAnimation;

@property (nonatomic) NSUInteger tag;
@property (nonatomic) SKTexture *origTexture;
+(void)loadSharedAssets;

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position;

// Abstract Methods - to be implemented by subclasses

// EFFECTS: Reset the character back to initial states: Putting them back to starting position, removing all items possessed. However, the HP remains unchanged.
-(void)reset;

// EFFECTS: Handle following animation after the jumping animation is complete, making ninja spin with the piles
-(void)animationDidComplete;

// EFFECTS: Update the angular speed for ninja's spinning when idle
- (void)updateAngularSpeed:(float) angularSpeed;

// EFFECTS: Handle physical collision
-(void)collideWith:(id)object;

// EFFECTS: Remove ninja from game
-(void)performDeath;

- (void)resetToPosition:(CGPoint)position;

// EFFECTS: Configure physics body to enable physics engine
-(void)configurePhysicsBody;

// EFFECTS: apply a given amount of damage to the character.
-(BOOL)applyDamage:(CGFloat)amount;

// EFFECTS:  a given amount of recover to the character.
-(void)recover:(CGFloat)amount;

- (void)attackCharacter:(NJCharacter *)character;

// EFFECTS: apply damage to the character according to the item causing the damage
//-(BOOL)applyDamageFromItem:(NJSpecialItem *)item;

// EFFECTS: character jump to a given position
- (void)jumpToPosition:(CGPoint)position fromPosition:(CGPoint)from withTimeInterval:(NSTimeInterval)timeInterval;
// EFFECTS: Only handle the animation of using the given item

//-(void)useItem:(NJSpecialItem *)item;

// EFFECTS: Update the next-frame renderring of the character
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

// EFFECTS: Load animation frames for jumping animation
- (NSArray *)jumpAnimationFrames;

// EFFECTS: load animation frames for death animation
- (NSArray *)deathAnimationFrames;

- (NSArray *)attackAnimationFrames;

- (void)addToScene:(NJMultiplayerLayeredCharacterScene *)scene;

- (void)pickupItemAtSamePosition:(NSArray *)items;
@end

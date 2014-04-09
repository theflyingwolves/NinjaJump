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

@class NJSpecialItem, NJMultiplayerLayeredCharacterScene, NJPlayer, NJPile;

@interface NJCharacter : SKSpriteNode
@property (nonatomic, weak) NJPlayer *player;
@property (nonatomic, getter=isDying) BOOL dying;
@property (nonatomic, getter=isAttacking) BOOL attacking;

@property float frozenCount;
@property SKSpriteNode *frozenEffect;

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

@property (nonatomic) float physicalDamageMultiplier;
@property (nonatomic) float magicalDamageMultiplier;
+(void)loadSharedAssets;

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position;

// Abstract Methods - to be implemented by subclasses

// EFFECTS: Reset the character back to initial states: Putting them back to starting position, removing all items possessed. However, the HP remains unchanged.
-(void)reset;

// EFFECTS: Handle following animation after the jumping animation is complete, making ninja spin with the piles
-(void)animationDidComplete;

// EFFECTS: Update the angular speed for ninja's spinning when idle
- (void)updateAngularSpeed:(float) angularSpeed;

// EFFECTS: Remove ninja from game
-(void)performDeath;

- (void)resetToPosition:(CGPoint)position;

// EFFECTS: Configure physics body to enable physics engine
-(void)configurePhysicsBody;

// EFFECTS: apply a given amount of damage to the character.
-(BOOL)applyDamage:(CGFloat)amount;

- (BOOL)applyMagicalDamage:(CGFloat)damage;

- (BOOL)applyPhysicalDamage:(CGFloat)damage;

// EFFECTS:  a given amount of recover to the character.
-(void)recover:(CGFloat)amount;

- (void)attackCharacter:(NJCharacter *)character;

// EFFECTS: character jump to a given position
- (void)jumpToPile:(NJPile*)toPile fromPile:(NJPile*)fromPile withTimeInterval:(NSTimeInterval)timeInterval;
// EFFECTS: Only handle the animation of using the given item

-(void)useItem:(NJSpecialItem *)item;

// EFFECTS: Update the next-frame renderring of the character
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

// EFFECTS: Load animation frames for jumping animation
- (NSArray *)jumpAnimationFrames;

// EFFECTS: load animation frames for death animation
- (NSArray *)deathAnimationFrames;

- (NSArray *)attackAnimationFrames;

- (NSArray *)thunderAnimationFrames;

- (void)addToScene:(NJMultiplayerLayeredCharacterScene *)scene;

- (void)pickupItem:(NSArray *)items onPile:(NJPile *)pile;

- (void)collidedWith:(SKPhysicsBody *)other;

//perform the animation when the character use the scroll
- (void)performThunderAnimationInScene:(NJMultiplayerLayeredCharacterScene*)scene;

- (void)performWindAnimationInScene:(NJMultiplayerLayeredCharacterScene *)scene direction:(CGFloat)direction;

//perform the animation when being applied the effect
- (void)performFrozenEffect;

@end

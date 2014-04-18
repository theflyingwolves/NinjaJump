//
//  NJCharacter.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJCharacter.h"
#import "NJSpecialItem.h"
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJGraphicsUnitilities.h"
#import "NJPile.h"
#import "NJRange.h"
#import "NJPlayer.h"
#import "NJConstants.h"

#define kThunderAnimationSpeed 0.125f
#define kFrozenEffectFileName @"freezeEffect.png"
#define kFrozenTime 2.0
#define kSoundAttack @"hurt.mid"

@implementation NJCharacter

-(instancetype)initWithTextureNamed:(NSString *)textureName AtPosition:(CGPoint)position delegate:(id<NJCharacterDelegate>)delegate
{
    self = [super initWithImageNamed:textureName];
    if (self) {
        self.delegate = delegate;
        self.position = position;
        self.movementSpeed = 800;
        self.animationSpeed = 1/60.0f;
        self.health = FULL_HP;
        self.origTexture = [SKTexture textureWithImageNamed:textureName];
        self.physicalDamageMultiplier = 1.0f;
        self.magicalDamageMultiplier = 1.0f;
        [self initShadow];
        [self configurePhysicsBody];
    }
    
    return self;
}

- (void)initShadow
{
    _shadow = [[SKSpriteNode alloc] initWithImageNamed:shadowImageName];
    _shadow.alpha = 0.7;
}

- (void)jumpToPile:(NJPile*)toPile fromPile:(NJPile*)fromPile withTimeInterval:(NSTimeInterval)timeInterval
{
    [self prepareForJump];
    self.requestedAnimation = NJAnimationStateJump;
    self.animated = YES;
    CGPoint curPosition = self.position;
    CGFloat dx = toPile.position.x - curPosition.x;
    CGFloat dy = toPile.position.y - curPosition.y;
    CGFloat dt = self.movementSpeed * timeInterval;
    CGFloat distRemaining = hypotf(dx, dy);
    
    CGFloat ang = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(toPile.position, curPosition));
    self.zRotation = normalizeZRotation(ang);
    if (distRemaining <= dt) {
        self.position = toPile.position;
        toPile.standingCharacter = self;
    } else {
        self.position = CGPointMake(curPosition.x - sinf(ang)*dt,
                                    curPosition.y + cosf(ang)*dt);
    }
    self.player.jumpTimerSprite.position = self.position;
    self.shadow.position = self.position;
}

- (void)prepareForJump
{
    [self removeActionForKey:@"anim_attack"];
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    if (self.isAnimated) {
        [self resolveRequestedAnimation];
    }
}

#pragma mark - Attack
- (void)attackCharacter:(NJCharacter *)character
{
    if (character.health <= 0) {
        return ; // to prevent the attack animation to be wrongly performed
    }
    [character applyPhysicalDamage:kAttackDamage];
    self.requestedAnimation = NJAnimationStateAttack;
    [self runAction:[SKAction playSoundFileNamed:kSoundAttack waitForCompletion:NO]];
}

#pragma mark - Death
- (void)performDeath
{
    self.health = 0.0f;
    self.dying = YES;
    self.requestedAnimation = NJAnimationStateDeath;
    self.alpha = 0;
    [self removeFromParent];
}

#pragma mark - Damage
- (BOOL)applyDamage:(CGFloat)damage
{
    self.health -= damage;
    if (self.health > 0.0f) {
        return NO;
    }else{
        [self performDeath];
        return YES;
    }
}

- (BOOL)applyMagicalDamage:(CGFloat)damage
{
    float multiplier = self.magicalDamageMultiplier;
    return [self applyDamage:damage * multiplier];
}

- (BOOL)applyPhysicalDamage:(CGFloat)damage
{
    float multiplier = self.physicalDamageMultiplier;
    return [self applyDamage:damage * multiplier];
}

// EFFECTS:  a given amount of recover to the character.
-(void)recover:(CGFloat)amount{
    [self applyDamage:(0-amount)];
    if (self.health > FULL_HP) {
        self.health = FULL_HP;
    }
}

#pragma mark - Resets
- (void)resetToPosition:(CGPoint)position
{
    self.position = position;
    SKSpriteNode *spawnEffect = [[SKSpriteNode alloc] initWithImageNamed:@"spawnLight"];
    spawnEffect.color = [SKColor yellowColor];
    spawnEffect.colorBlendFactor = 4.0;
    [self addChild:spawnEffect];
    SKAction *blink = [SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.25],[SKAction fadeAlphaTo:0.4 duration:0.25]]];
    [spawnEffect runAction:[SKAction sequence:@[[SKAction repeatAction:blink count:4],[SKAction removeFromParent]]]];
}

- (void)reset
{
    self.health = FULL_HP;
    self.dying = NO;
    self.attacking = NO;
    self.animated = NO;
    [self removeAllActions];
}

#pragma mark - Use Items
- (void)useItem:(NJSpecialItem *)item
{
    
}

- (void)performThunderAnimation
{
    SKSpriteNode *thunderEffect = [[SKSpriteNode alloc] initWithImageNamed:@"ninja_thunder_001.png"];
    thunderEffect.position = self.position;
    [self.delegate addEffectNode:thunderEffect];
    [thunderEffect runAction:[SKAction sequence:@[
                                         [SKAction animateWithTextures:[self thunderAnimationFrames] timePerFrame:kThunderAnimationSpeed resize:YES restore:YES],
                                         [SKAction runBlock:^{
        [thunderEffect removeFromParent];
    }]]]];
}

- (void)performWindAnimationInDirection:(CGFloat)direction
{
    SKSpriteNode *windEffect= [[SKSpriteNode alloc] initWithImageNamed:@"wind.png"];
    windEffect.position = self.position;
    [self.delegate addEffectNode:windEffect];
    CGVector vector = CGVectorMake(2000*cos(direction), 2000*sin(direction));
    SKAction *move = [SKAction moveBy:vector duration:1];
    SKAction *rotate = [SKAction rotateByAngle:M_PI*6 duration:1];
    SKAction *group = [SKAction group:@[move,rotate]];
    [windEffect runAction:group completion:^{
        [windEffect removeFromParent];
    }];
}

#pragma mark - Animation
- (void)resolveRequestedAnimation
{
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    NJAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
        case NJAnimationStateJump:
            animationKey = @"anim_jump";
            animationFrames = [self jumpAnimationFrames];
            break;
        case NJAnimationStateDeath:
            animationKey = @"anim_death";
            animationFrames = [self deathAnimationFrames];
            break;
        case NJAnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [self attackAnimationFrames];
            break;
        default:
            break;
    }
    
    if (animationKey) {
        if (animationState == NJAnimationStateAttack) {
            [self removeActionForKey:@"anim_jump"];
        }
        
        [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
    }
}

- (void)fireAnimationForState:(NJAnimationState)animationState usingTextures:(NSArray *)animationFrames withKey:(NSString *)animationKey
{
    SKAction *animAction = [self actionForKey:animationKey];
    if (animAction || [animationFrames count] < 1) {
        return; // we already have a running animation or there aren't any frames to animate
    }
    
    self.activeAnimationKey = animationKey;
    [self runAction:[SKAction sequence:@[
                                         [SKAction animateWithTextures:animationFrames timePerFrame:self.animationSpeed resize:YES restore:YES],
                                         [SKAction runBlock:^{
        [self animationHasCompleted:animationState];
    }]]] withKey:animationKey];
}

- (void)animationHasCompleted:(NJAnimationState)animationState
{
    self.animated = NO;
    self.activeAnimationKey = nil;
    if (animationState == NJAnimationStateAttack) {
        [self removeActionForKey:@"anim_attack"];
        self.texture = self.origTexture;
    }
}

- (void)addToScene:(NJMultiplayerLayeredCharacterScene *)scene
{
    [scene addNode:self atWorldLayer:NJWorldLayerCharacter];
}

- (void)render
{
    [self.delegate addCharacter:self];
}

#pragma mark - Shared Assets
+ (void)loadSharedAssets {
    // overridden by subclasses
}


#pragma mark - Abstract Methods
- (NSArray *)jumpAnimationFrames
{
    // overridden by subclasses
    return nil;
}

- (NSArray *)deathAnimationFrames
{
    // overridden by subclasses
    return nil;
}

- (NSArray *)attackAnimationFrames
{
    // overridden by subclasses
    return nil;
}

- (SKAction *)damageAction
{
    // overridden by subclasses
    return nil;
}

#pragma mark - animation when applied effect
- (void)performFrozenEffect{
    SKSpriteNode *frozen = [[SKSpriteNode alloc] initWithImageNamed:kFrozenEffectFileName];
    frozen.alpha = 0.8;
    frozen.position = CGPointMake(0, 0);
    frozen.zPosition = self.zPosition+1;
    [self addChild:frozen];
    
    self.frozenEffect = frozen;
    self.frozenCount = kFrozenTime;
}

#pragma mark - Abstract Methods
- (void)animationDidComplete
{
    // Overridden by Subclasses
}

- (void)updateAngularSpeed:(float)angularSpeed
{
    // Overridden by Subclasses
}

- (NSArray *)thunderAnimationFrames
{
    // Overridden by Subclasses
    return nil;
}

- (void)collidedWith:(SKPhysicsBody *)other
{
    //overriden by subclasses
}

-(void)configurePhysicsBody
{
    //overriden by subclasses
}

- (void)pickupItem:(NSArray *)items onPile:(NJPile *)pile
{
    //overriden by subclasses
}
@end
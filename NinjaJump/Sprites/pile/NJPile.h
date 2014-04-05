//
//  NJPile.h
//  NinjaJump
//
//  Created by wulifu on 19/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
    NJDiectionClockwise = 0,
    NJDirectionCounterClockwise
} NJDirection;

@class NJCharacter, NJSpecialItem;

@interface NJPile : SKSpriteNode

@property float radius; //do we really need it?
@property float speed;
@property float angularSpeed;
@property float angleRotatedSinceLastUpdate;
@property NJDirection rotateDirection;
@property (nonatomic, weak) NJCharacter *standingCharacter;
@property (nonatomic, weak) NJSpecialItem *itemHolded;
@property BOOL isIceScrollEnabled;
@property BOOL isOnFire;
@property (nonatomic) NSTimeInterval fireTimer;
@property (nonatomic) SKEmitterNode *fireEmitter;

/* Preload texture */
//+(void)loadSharedAssets;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position withSpeed:(float)speed angularSpeed:(float)aSpeed direction:(NJDirection)direction;

// EFFECTS: Update the next-frame renderring of the pile
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

- (void)addCharacterToPile:(NJCharacter *)character;
- (void)setSpeed:(float)aSpeed direction:(NJDirection)direction;

- (void)removeStandingCharacter;
@end

//
//  NJMultiplayerLayeredCharacterScene.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AVFoundation/AVfoundation.h"

/* The layers in a scene. */
typedef enum : uint8_t {
	NJWorldLayerGround = 0,
	NJWorldLayerBelowCharacter,
	NJWorldLayerCharacter,
	NJWorldLayerAboveCharacter,
    NJWorldLayerControl,
	kWorldLayerCount
} NJWorldLayer;

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    NJColliderTypeCharacter = 1,
    NJColliderTypeItemEffect = 2,
    NJColliderTypeWoodPile = 4
} NJColliderType;

#define kMinTimeInterval (1.0f / 60.0f)
#define kNumPlayers 4
#define kJumpCooldownTime 0.5f

/* Completion handler for callback after loading assets asynchronously. */
typedef void (^NJAssetLoadCompletionHandler)(void);

/* Forward declarations */
@class NJNinjaCharacter, NJPlayer, NJNinjaCharacterNormal, NJPile;

@interface NJMultiplayerLayeredCharacterScene : SKScene

@property (nonatomic, readonly) NSArray *players;               // array of player objects or NSNull for no playerf
@property (nonatomic, readonly) SKNode *world;                  // root node to which all game renderables are attached
@property (nonatomic, readonly) NSArray *ninjas;                // all ninjas in the game
@property (nonatomic, readonly) NSArray *items;                 // all items currently in the game
@property (nonatomic, readonly) NSArray *woodPiles;             // all wood piles in the game

/* All sprites in the scene should be added through this method to ensure they are placed in the correct world layer. */
- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer;

/* Start loading all the shared assets for the scene in the background. This method calls +loadSceneAssets
 on a background queue, then calls the callback handler on the main thread. */
+ (void)loadSceneAssetsWithCompletionHandler:(NJAssetLoadCompletionHandler)callback;

/* Overridden by subclasses to load scene-specific assets. */
+ (void)loadSceneAssets;

/* Overridden by subclasses to release assets used only by this scene. */
+ (void)releaseSceneAssets;

/* Overridden by subclasses to update the scene - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast;

/* Heroes and players. */
- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player;

- (NJPile *)spawnAtRandomPile;
@end

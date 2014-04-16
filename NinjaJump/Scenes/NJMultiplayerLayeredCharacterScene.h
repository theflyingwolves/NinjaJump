//
//  NJLevelSceneWaterPark.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJResponsibleBG.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NJConstants.h"


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
    NJColliderTypeItemEffectShuriken = 2,
    NJColliderTypeWoodPile = 4,
    NJColliderTypeItemEffectMine = 8
} NJColliderType;

#define kMinTimeInterval (1.0f / 60.0f)
#define kNumPlayers 4
#define kJumpCooldownTime 0.7f
#define kFireLastTime 5.0f
#define kPileDecreaseTimeInterval 10.0f
#define kMaxItemLifeTime 15.0f

/* Completion handler for callback after loading assets asynchronously. */
typedef void (^NJAssetLoadCompletionHandler)(void);

/* Forward declarations */
@class NJNinjaCharacter, NJPlayer, NJNinjaCharacterNormal, NJPile;

@protocol NJMultiplayerLayeredCharacterSceneDelegate <NSObject>
- (void)backToModeSelectionScene;
@end

@interface NJMultiplayerLayeredCharacterScene:SKScene

@property (nonatomic) BOOL startGame;

@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic, readwrite) NSMutableArray *woodPiles;// all the wood piles in the scene
@property (nonatomic ,readwrite) NSMutableArray *items;
@property (nonatomic, readwrite) NSMutableArray *players;          // array of player objects or NSNull for no player

@property (nonatomic, readwrite) SKNode *world;                    // root node to which all game renderables are attached
@property (nonatomic) NSMutableArray *layers;                      // different layer nodes within the world
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray *itemControls;
@property (nonatomic) NSMutableArray *hpBars;
@property (nonatomic) SKSpriteNode *continueButton;
@property (nonatomic) NJResponsibleBG *clickableArea;

@property (nonatomic) SKSpriteNode *victoryBackground;

@property (nonatomic) NSTimeInterval pileDecreaseTime;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval; // the previous update: loop time interval
@property (nonatomic) id<NJMultiplayerLayeredCharacterSceneDelegate> delegate;
@property BOOL doAddItemRandomly;

@property (nonatomic) NSArray *musicName;

- (instancetype)initWithSize:(CGSize)size mode:(NJGameMode)mode;




/* All sprites in the scene should be added through this method to ensure they are placed in the correct world layer. */
- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer;

/* Start loading all the shared assets for the scene in the background. This method calls +loadSceneAssets
 on a background queue, then calls the callback handler on the main thread. */
+ (void)loadSceneAssetsWithCompletionHandler:(NJAssetLoadCompletionHandler)callback;

/* Overridden by subclasses to load scene-specific assets. */
+ (void)loadSceneAssets;

/* Overridden by subclasses to update the scene - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast;

/* Heroes and players. */
- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player;

- (NJPile *)spawnAtRandomPileForNinja:(BOOL)isNinja;

/* for the use of tutorial scene */
- (void) activateSelectedPlayersWithPreSetting;

- (void)resetMusic;

@end

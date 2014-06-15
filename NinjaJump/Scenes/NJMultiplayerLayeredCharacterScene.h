//
//  NJLevelSceneWaterPark.h
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJItemEffect.h"
#import "NJResponsibleBG.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NJConstants.h"
#import "NJItemEffect.h"
#import "NJGameAttribute.h"
#import "NJStore.h"

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
    NJColliderTypeCharacter = 0x1<<0,
    NJColliderTypeItemEffectShuriken = 0x1<<1,
    NJColliderTypeWoodPile = 0x1<<2,
    NJColliderTypeItemEffectMine = 0x1<<3
} NJColliderType;

#define kMinTimeInterval (1.0f / 60.0f)
#define kNumPlayers 4
#define kFireLastTime 5.0f
#define kPileDecreaseTimeInterval 10.0f
#define kMaxItemLifeTime 15.0f

/* Completion handler for callback after loading assets asynchronously. */
typedef void (^NJAssetLoadCompletionHandler)(void);

/* Forward declarations */
@class NJNinjaCharacter, NJPlayer, NJNinjaCharacterNormal, NJPile, NJRange;

@protocol NJMultiplayerLayeredCharacterSceneDelegate <NSObject>
// EFFECTS: Signals the delegate that a back transition is required.
- (void)backToModeSelectionScene;
@end

@interface NJMultiplayerLayeredCharacterScene:SKScene <NJItemEffectSceneDelegate>
@property (nonatomic) NJGameAttribute *attribute;
@property (nonatomic) NSMutableArray *ninjas;                   // array of ninja character objects in the scene
@property (nonatomic) NSMutableArray *AICharacters;             // array of AI character objects
@property (nonatomic) NSMutableArray *woodPiles;                // array of woodpile object in the scene
@property (nonatomic) NSMutableArray *items;                    // array of special item objects currently in the scene
@property (nonatomic) NSMutableArray *players;                  // array of player objects
@property (nonatomic) NSMutableArray *AIplayers;                  // array of AI player objects
@property (nonatomic) SKNode *world;                            // root node to which all game renderables are attached
@property (nonatomic) NSMutableArray *layers;                   // different layer nodes within the world
@property (nonatomic) NSMutableArray *buttons;                  // array of jump button objects
@property (nonatomic) NSMutableArray *itemControls;             // array of use item button objects
@property (nonatomic) NSMutableArray *hpBars;                   // array of health point bar objects
@property (nonatomic) SKSpriteNode *continueButton;             // continue button that presents after game ends
@property (nonatomic) NJResponsibleBG *clickableArea;           // an invisible rectangle area at the center of the scene
@property (nonatomic) SKSpriteNode *victoryBackground;          // vicotry background node
@property (nonatomic) NSTimeInterval pileDecreaseTime;          // the previous a wood pile decresed time interval
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;    // the previous update: loop time interval
@property (nonatomic) NSArray *musicName;                       // array of music names
@property (nonatomic) AVAudioPlayer *music;                     // an audio player
@property (nonatomic) BOOL isBossLost;                          // indicates whether boss player loses in 1 vs 3 mode
@property (nonatomic) BOOL doAddItemRandomly;                   // indicates whether add item randomly to the scene
@property (nonatomic) id<NJMultiplayerLayeredCharacterSceneDelegate> delegate;
@property (nonatomic) NSMutableArray *usableItemTypes;
@property (nonatomic) NJStore *store;

/* Start loading all the shared assets for the scene in the background. This method calls +loadSceneAssets
 on a background queue, then calls the callback handler on the main thread. */
+ (void)loadSceneAssetsWithCompletionHandler:(NJAssetLoadCompletionHandler)callback;

/* Overridden by subclasses to load scene-specific assets. */
+ (void)loadSceneAssets;

/* Designated initializer. */
- (instancetype)initWithSize:(CGSize)size mode:(NJGameMode)mode store:(NJStore *)store;

/* All sprites in the scene should be added through this method to ensure they are placed in the correct world layer. */
- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer;

/* Overridden by subclasses to update the scene - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast;

/* Adds a ninja the a specific player. */
- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player;

/* Returns a random woodpile to spawn for ninja or item */
- (NJPile *)spawnAtRandomPileForNinja:(BOOL)isNinja;

/* for the use of tutorial scene. */
- (void) activateSelectedPlayersWithPreSetting;

/* resets the background music. */
- (void)resetMusic;

/* the following two methods are defined in NJScroll delegate they are declared here in order to be used by tutorial scene. */
- (NSArray *)getAffectedTargetsWithRange:(NJRange *)range;
- (NSArray *)getAffectedPilesWithRange:(NJRange *)range;

- (BOOL)containsPile:(NJPile *)pile;

- (NJPile *)woodPileToJump:(NJCharacter *)ninja;

- (NJCharacter *)getNearestCharacter:(NJCharacter *)ninja;

- (BOOL)isPileTargeted:(NJPile *)pile;

@end

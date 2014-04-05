//
//  NJMultiplayerLayeredCharacterScene.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJPlayer.h"
#import "NJNinjaCharacter.h"
#import "NJNinjaCharacterNormal.h"
#import "NJButton.h"
#import "NJSpecialItem.h"
#import "NJGraphicsUnitilities.h"
#import "NJItemControl.h"
#import "NJPile.h"
#import "NJThunderScroll.h"
#import "NJWindScroll.h"
#import "NJFireScroll.h"
#import "NJIceScroll.h"

#define kMaxItemLifeTime 15.0f

@interface NJMultiplayerLayeredCharacterScene ()

@property (nonatomic, readwrite) NSMutableArray *players;          // array of player objects or NSNull for no player
@property (nonatomic, readwrite) SKNode *world;                    // root node to which all game renderables are attached
@property (nonatomic) NSMutableArray *layers;                      // different layer nodes within the world
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic, readwrite) NSMutableArray *items;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval; // the previous update: loop time interval

@end

@implementation NJMultiplayerLayeredCharacterScene

#pragma mark - Initialization
- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _players = [[NSMutableArray alloc] initWithCapacity:kNumPlayers];

        for (int i=0; i<kNumPlayers ; i++) {
            NJPlayer *player = [[NJPlayer alloc] init];
            [(NSMutableArray *)_players addObject:player];
        }
        
        _world = [[SKNode alloc] init];
        [_world setName:@"world"];
        _layers = [NSMutableArray arrayWithCapacity:kWorldLayerCount];
        for (int i = 0; i < kWorldLayerCount; i++) {
            SKNode *layer = [[SKNode alloc] init];
            layer.zPosition = i - kWorldLayerCount;
            [_world addChild:layer];
            [(NSMutableArray *)_layers addObject:layer];
        }
        [self addChild:_world];
    }
    return self;
}

- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

#pragma mark - Heroes and Players

- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player
{
    NSAssert(![player isKindOfClass:[NSNull class]], @"Player should not be NSNull");
    
    if (player.ninja && !player.ninja.dying) {
        [player.ninja removeFromParent];
        [player.indicatorNode removeFromParent];
    }
    
    NJNinjaCharacterNormal *ninja = [[NJNinjaCharacterNormal alloc] initWithTextureNamed:@"ninja.png" atPosition:CGPointZero withPlayer:player];
    if (ninja) {
        [ninja addToScene:self];
        [(NSMutableArray *)self.ninjas addObject:ninja];
    }
    ninja.color = player.color;
    ninja.colorBlendFactor = 0.6;
    player.ninja = ninja;
    
    return ninja;
}

#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    NSTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = kMinTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    for (NJPlayer *player in self.players) {
        if ((id)player == [NSNull null]) {
            continue;
        }
        NJNinjaCharacter *ninja = nil;
        if ([self.ninjas count] > 0){
            ninja = player.ninja;
        }
        
        if (player.item) {
            NSString *fileName;
            if ([player.item isKindOfClass:[NJThunderScroll class]]) {
                fileName = @"indicator_thunder";
            }else if([player.item isKindOfClass:[NJWindScroll class]]){
                fileName = @"indicator_wind";
            }else if([player.item isKindOfClass:[NJFireScroll class]]){
                fileName = @"indicator_fire";
            }else if([player.item isKindOfClass:[NJIceScroll class]]){
                fileName = @"indicator_ice";
            }
            
            if (!player.itemIndicatorAdded && fileName) {
                if (player.indicatorNode) {
                    [player.indicatorNode removeFromParent];
                }
                SKSpriteNode *itemIndicator = [SKSpriteNode spriteNodeWithImageNamed:fileName];
                itemIndicator.alpha = 0.2;
                [self addNode:itemIndicator atWorldLayer:NJWorldLayerCharacter];
                player.indicatorNode = itemIndicator;
                player.itemIndicatorAdded = YES;
            }
        }else{
            player.indicatorNode = nil;
        }
        
        if (player.indicatorNode) {
            player.indicatorNode.position = player.ninja.position;
            player.indicatorNode.zRotation = player.ninja.zRotation;
        }
        
        if (![ninja isDying]) {
            ninja.position = CGPointApprox(ninja.position);
            if (ninja.frozenCount > 0) {
                ninja.frozenCount -= timeSinceLast;
            }
            if (ninja.frozenCount < 0) {
                ninja.frozenCount = 0;
                [ninja.frozenEffect removeFromParent];
                ninja.frozenEffect = nil;
            }
            player.jumpCooldown += timeSinceLast;
            if (player.jumpRequested) {
                if (player.fromPile.standingCharacter == ninja) {
                    player.fromPile.standingCharacter = nil;
                }
                //if (!CGPointEqualToPointApprox(player.targetPile.position, ninja.position)) {
                if (hypotf(ninja.position.x-player.targetPile.position.x, ninja.position.y-player.targetPile.position.y)>CGRectGetWidth(player.targetPile.frame)/2) {
                    [ninja jumpToPile:player.targetPile fromPile:player.fromPile withTimeInterval:timeSinceLast];
                } else {
                    player.jumpRequested = NO;
                    player.isJumping = NO;
                    //resolve attack events
                    for (NJPlayer *p in _players) {
                        if (p == player) {
                            continue;
                        }
                        if (hypotf(ninja.position.x-p.ninja.position.x,ninja.position.y-p.ninja.position.y)<=CGRectGetWidth(player.targetPile.frame)/2) {
                            if (!p.isDisabled) {
                                [ninja attackCharacter:p.ninja];
                                NJPile *pile = [self spawnAtRandomPile];
                                pile.standingCharacter = p.ninja;
                                [p.ninja resetToPosition:pile.position];
                            }
                        }
                    }
                    if (player.targetPile.standingCharacter) {
                        player.targetPile.standingCharacter = nil;
                    }
                    player.targetPile.standingCharacter = ninja;
                    ninja.position = player.targetPile.position;
                    //pick up items if needed
                    [player.ninja pickupItem:self.items onPile:player.targetPile];
                    player.itemIndicatorAdded = NO;
                }
            }
        }
    }
    
    NSMutableArray *itemsToRemove = [NSMutableArray array];
    for (NJSpecialItem *item in self.items){
        if (item.isPickedUp) {
            [itemsToRemove addObject:item];
        }
    }
    
    for (id item in itemsToRemove){
        [(NSMutableArray*)self.items removeObject:item];
    }
    
    itemsToRemove = [NSMutableArray array];
    for (NJSpecialItem *item in self.items){
        if (item.lifeTime > kMaxItemLifeTime) {
            [itemsToRemove addObject:item];
        }
    }
    for (NJSpecialItem *item in itemsToRemove){
        [item removeFromParent];
        [(NSMutableArray*)self.items removeObject:item];
    }
}

- (NJPile *)spawnAtRandomPile
{
    // Overridden by subclasses
    return nil;
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    // Overridden by subclasses.
}

- (void)didSimulatePhysics
{
    
}

#pragma mark - Shared Assets
+ (void)loadSceneAssetsWithCompletionHandler:(NJAssetLoadCompletionHandler)handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Load the shared assets in the background.
        [self loadSceneAssets];
        
        if (!handler) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Call the completion handler back on the main queue.
            handler();
        });
    });
}

+ (void)loadSceneAssets
{
    // Overridden by subclasses.
}

+ (void)releaseSceneAssets
{
    // Overridden by subclasses.
}

- (SKEmitterNode *)sharedSpawnEmitter
{
    // Overridden by subclasses.
    return nil;
}

@end

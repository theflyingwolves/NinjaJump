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

@interface NJMultiplayerLayeredCharacterScene () <NJButtonDelegate>

@property (nonatomic) NSMutableArray *players;          // array of player objects or NSNull for no player
@property (nonatomic) SKNode *world;                    // root node to which all game renderables are attached
@property (nonatomic) NSMutableArray *layers;           // different layer nodes within the world
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic) NSMutableArray *buttons;

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval; // the previous update: loop time interval

@end

@implementation NJMultiplayerLayeredCharacterScene

#pragma mark - Initialization
- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _players = [[NSMutableArray alloc] initWithCapacity:kNumPlayers];
        for (int i=0; i<kNumPlayers ; i++) {
            NJPlayer *player = [[NJPlayer alloc] init];
            [(NSMutableArray *)_players addObject:player];
            player.spawnPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
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
        _buttons = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            NJButton *button = [[NJButton alloc] initWithImageNamed:@"bubble-red"];
            button.delegate = self;
            [_buttons addObject:button];
            [self addChild:button];
        }
        ((SKSpriteNode*)_buttons[0]).position = CGPointMake(50, 50);
        ((SKSpriteNode*)_buttons[1]).position = CGPointMake(974, 50);
        ((SKSpriteNode*)_buttons[2]).position = CGPointMake(50, 718);
        ((SKSpriteNode*)_buttons[3]).position = CGPointMake(974, 718);
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
    
    /*
    if (player.ninja && !player.ninja.dying) {
        [player.ninja removeFromParent];
    }
    */
    CGPoint spawnPos = player.spawnPoint;
    
    NJNinjaCharacterNormal *ninja = [[NJNinjaCharacterNormal alloc] initWithTextureNamed:@"ninja.png" atPosition:spawnPos withPlayer:player];
    if (ninja) {
        [ninja addToScene:self];
        [(NSMutableArray *)self.ninjas addObject:ninja];
    }
    player.ninja = ninja;
    
    return ninja;
}

#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
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
        if ([self.ninjas count] > 0) {
            ninja = player.ninja;
        }
        if (![ninja isDying]) {
            if (player.jumpRequested) {
                if (!CGPointEqualToPoint(player.targetLocation, ninja.position)) {
                    [ninja jumpToPosition:player.targetLocation withTimeInterval:timeSinceLast];
                } else {
                    player.jumpRequested = NO;
                }
            }
        }
    }
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    // Overridden by subclasses.
}

#pragma mark - Event Handling

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches {
    NSArray *ninjas = self.ninjas;
    if ([ninjas count] < 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    NJNinjaCharacter *ninja = [ninjas firstObject];
    ninja.player.targetLocation = [touch locationInNode:ninja.parent];
    ninja.player.jumpRequested = YES;
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

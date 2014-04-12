//
//  NJLevelSceneWaterPark.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJNinjaCharacter.h"
#import "NJPile.h"
#import "NJButton.h"
#import "NJItemControl.h"
#import "NJHPBar.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"
#import "NJNinjaCharacterNormal.h"
#import "NJSelectionButtonSystem.h"
#import "NJResponsibleBG.h"
#import "NJPausePanel.h"

#import "NJScroll.h"
#import "NJThunderScroll.h"
#import "NJWindScroll.h"
#import "NJIceScroll.h"
#import "NJFireScroll.h"
#import "NJMine.h"
#import "NJShuriken.h"
#import "NJMedikit.h"

#import "NJItemEffect.h"

@interface NJMultiplayerLayeredCharacterScene ()  <SKPhysicsContactDelegate, NJButtonDelegate,NJItemControlDelegate, NJBGclickingDelegate, NJScrollDelegate>

@end

@implementation NJMultiplayerLayeredCharacterScene{
    NJGameMode _gameMode;
    BOOL isSelectionInited;
    BOOL isFirstTimeInitialized;
    BOOL isGameEnded;
    BOOL shouldPileStartDecreasing;
    NSArray *musicName;
    AVAudioPlayer *music;
}

#pragma mark - Initialization
- (instancetype)initWithSize:(CGSize)size mode:(NJGameMode)mode
{
    self = [self initWithSize:size];
    if (self) {
        _gameMode = mode;
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
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.friction = 0.0;
        self.physicsBody.linearDamping = 0.0;
        self.physicsBody.restitution = 1.0;
        _ninjas = [[NSMutableArray alloc] init];
        _items = [[NSMutableArray alloc] init];
        _woodPiles = [[NSMutableArray alloc] init];
        isSelectionInited = NO;
        isFirstTimeInitialized = YES;
        isGameEnded = NO;
        shouldPileStartDecreasing = NO;
        [self buildWorld];
        
        musicName = [NSArray arrayWithObjects:kMusicPatrit, kMusicWater, kMusicShadow, kMusicSun, kMusicFunny, nil];
        [self resetMusic];
        [self initSelectionSystem];
    }
    return self;
}

- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)initHpBars
{
    if (!_hpBars) {
        _hpBars = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    
    for (int i=0; i < kNumPlayers; i++) {
        CGPoint position;
        float size = 250;
        float offset = 10;
        switch (i) {
            case 0:
                position = CGPointMake(size / 2 + offset, size / 2 + offset);
                break;
            case 1:
                position = CGPointMake(self.frame.size.width - size / 2 - offset, size / 2+offset);
                break;
            case 2:
                position = CGPointMake(self.frame.size.width - size / 2 - offset, self.frame.size.height - size / 2 - offset);
                break;
            case 3:
                position = CGPointMake(size / 2 + offset, self.frame.size.height - size / 2 - offset);
                break;
            default:
                break;
        }
        
        NJPlayer *player = self.players[i];
        if ([_hpBars count] < kNumPlayers) {
            NJHPBar *bar = [NJHPBar hpBarWithPosition:position andPlayer:self.players[i]];
            float angle = i * M_PI / 2 - M_PI / 2;
            bar.zRotation = angle;
            [_hpBars addObject:bar];
        }

        if (!player.isDisabled) {
            if (!((NJHPBar *)_hpBars[i]).parent) {
                [self addChild:_hpBars[i]];
            }
        }else{
            [(NJHPBar *)_hpBars[i] removeFromParent];
        }
    }
}

- (void)initButtonsAndItemControls
{
    double xDiff = 40, yDiff=90;

    if (!_itemControls) {
        _itemControls = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    
    for (int i=0; i<kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        
        if ([_itemControls count]<kNumPlayers) {
            NJItemControl *control = [[NJItemControl alloc] initWithImageNamed:@"itemControl"];
            control.delegate = self;
            control.player = self.players[i];
            [_itemControls addObject:control];
        }
        
        if (!player.isDisabled) {
            if (!((NJItemControl *)_itemControls[i]).parent) {
                [self addChild:_itemControls[i]];
            }
        }else{
            [(NJItemControl *)_itemControls[i] removeFromParent];
        }
    }
    
    ((NJItemControl *)_itemControls[0]).position = CGPointMake(yDiff, xDiff);
    ((NJItemControl *)_itemControls[0]).zRotation = - M_PI / 4;
    ((NJItemControl *)_itemControls[0]).color = [SKColor blackColor];
    ((NJItemControl *)_itemControls[0]).colorBlendFactor = 1.0;
    ((NJItemControl *)_itemControls[1]).position = CGPointMake(1024-xDiff, yDiff);
    ((NJItemControl *)_itemControls[1]).zRotation = M_PI / 4;
    ((NJItemControl *)_itemControls[1]).color = [SKColor blueColor];
    ((NJItemControl *)_itemControls[1]).colorBlendFactor = 1.0;
    ((NJItemControl *)_itemControls[2]).position = CGPointMake(1024-yDiff, 768-xDiff);
    ((NJItemControl *)_itemControls[2]).zRotation = -3* M_PI / 4;
    ((NJItemControl *)_itemControls[2]).color = [SKColor yellowColor];
    ((NJItemControl *)_itemControls[2]).colorBlendFactor = 1.0;
    ((NJItemControl *)_itemControls[3]).position = CGPointMake(xDiff, 768-yDiff);
    ((NJItemControl *)_itemControls[3]).zRotation = 3*M_PI / 4;
    ((NJItemControl *)_itemControls[3]).color = [SKColor redColor];
    ((NJItemControl *)_itemControls[3]).colorBlendFactor = 1.0;
    
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    
    for (int i = 0; i < kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        
        if ([_buttons count]<kNumPlayers) {
            NJButton *button = [[NJButton alloc] initWithImageNamed:@"jumpButton"];
            button.delegate = self;
            button.player = self.players[i];
            [_buttons addObject:button];
        }
        
        if (!player.isDisabled) {
            if (!((NJButton *)_buttons[i]).parent) {
                [self addChild:_buttons[i]];
            }
        }else{
            [(NJButton *)_buttons[i] removeFromParent];
        }
    }
    
    ((NJButton*)_buttons[0]).position = CGPointMake(0+xDiff, 0+yDiff);
    ((NJButton*)_buttons[0]).zRotation = -M_PI/4;
    ((NJButton*)_buttons[0]).color = [SKColor blackColor];
    ((NJButton*)_buttons[0]).colorBlendFactor = 1.0;
    ((NJButton*)_buttons[0]).player.color = [SKColor blackColor];
    ((NJButton*)_buttons[1]).position = CGPointMake(1024-yDiff, xDiff);
    ((NJButton*)_buttons[1]).zRotation = M_PI/4;
    ((NJButton*)_buttons[1]).color = [SKColor blueColor];
    ((NJButton*)_buttons[1]).colorBlendFactor = 1.0;
    ((NJButton*)_buttons[1]).player.color = [SKColor blueColor];
    ((NJButton*)_buttons[2]).position = CGPointMake(1024-xDiff, 768-yDiff);
    ((NJButton*)_buttons[2]).zRotation = -M_PI/4*3;
    ((NJButton*)_buttons[2]).color = [SKColor yellowColor];
    ((NJButton*)_buttons[2]).colorBlendFactor = 1.0;
    ((NJButton*)_buttons[2]).player.color = [SKColor yellowColor];
    ((NJButton*)_buttons[3]).position = CGPointMake(yDiff, 768-xDiff);
    ((NJButton*)_buttons[3]).zRotation = M_PI/4*3;
    ((NJButton*)_buttons[3]).color = [SKColor redColor];
    ((NJButton*)_buttons[3]).colorBlendFactor = 1.0;
    ((NJButton*)_buttons[3]).player.color = [SKColor redColor];
}

- (void)initCharacters
{
    if (!_ninjas) {
        _ninjas = [NSMutableArray array];
    }
    [_ninjas removeAllObjects];
    
    for (int index=0; index<4; index++) {
        NJPlayer *player = self.players[index];
        if (!player.isDisabled) {
            NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
            NJPile *pile = [self spawnAtRandomPileForNinja:NO];
            pile.standingCharacter = ninja;
            ninja.position = pile.position;
        }else if(player.ninja){
            [_ninjas removeObject:player.ninja];
            [player.ninja removeFromParent];
        }
    }
}

#pragma mark - Heroes and Players

- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player
{
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

#pragma mark - World Building
- (void)buildWorld {
    NSLog(@"Building the world");
    
    // Configure physics for the world.
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f); // no gravity
    self.physicsWorld.contactDelegate = self;
    
    [self addBackground];
    [self addWoodPiles];
    [self addClickableArea];
}

- (void)addItem{
    NJPile *pile = [self spawnAtRandomPileForNinja:NO];
    if (!pile || [self.items count]>=3 ) {
        return;
    }
    CGPoint position = pile.position;
    
    if (_gameMode == NJGameModeBeginner) {
        int index = arc4random() % 2;
        NJSpecialItem *item;
        switch (index) {
            case 0:
                item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
                break;
            case 1:
                item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
                break;
            default:
                break;
        }
        if (item != nil) {
            item.myParent = self;
            pile.itemHolded = item;
            [self addNode:item atWorldLayer:NJWorldLayerCharacter];
            [_items addObject:item];
        }
        return;
    }
    
    int index = arc4random() % NJItemCount;
    NJSpecialItem *item;
    
    switch (index) {
        case NJItemThunderScroll:
            item = [[NJThunderScroll alloc] initWithTextureNamed:kThunderScrollFileName atPosition:position delegate:self];
            break;
            
        case NJItemWindScroll:
            item = [[NJWindScroll alloc] initWithTextureNamed:kWindScrollFileName atPosition:position delegate:self];
            break;
            
        case NJItemIceScroll:
            item = [[NJIceScroll alloc] initWithTextureNamed:kIceScrollFileName atPosition:position delegate:self];
            break;
            
        case NJItemFireScroll:
            item = [[NJFireScroll alloc] initWithTextureNamed:kFireScrollFileName atPosition:position delegate:self];
            break;
            
        case NJItemMedikit:
            item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
            break;
            
        case NJItemMine:
            item = [[NJMine alloc] initWithTextureNamed:kMineFileName atPosition:position];
            break;
            
        case NJItemShuriken:
            item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
            break;
            
        default:
            break;
    }
    
    if (item != nil) {
        item.myParent = self;
        pile.itemHolded = item;
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [_items addObject:item];
    }
}

- (BOOL)hasItemOnPosition:(CGPoint)position{
    for (NJSpecialItem *item in self.items){
        if (CGPointEqualToPointApprox(position, item.position)) {
            return YES;
        }
    }
    return NO;
}

- (void)addWoodPiles
{
    CGFloat r= 120.0f;
    NSArray *pilePos = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:CGPointMake(r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(512, 580)], [NSValue valueWithCGPoint:CGPointMake(250, 250)], [NSValue valueWithCGPoint:CGPointMake(350, 100)], [NSValue valueWithCGPoint:CGPointMake(650, 350)], [NSValue valueWithCGPoint:CGPointMake(850, 400)], [NSValue valueWithCGPoint:CGPointMake(100, 300)], [NSValue valueWithCGPoint:CGPointMake(250, 500)], [NSValue valueWithCGPoint:CGPointMake(550, 400)], [NSValue valueWithCGPoint:CGPointMake(700, 600)], [NSValue valueWithCGPoint:CGPointMake(750, 150)], nil];
    //add in the spawn pile of ninjas
    for (NSValue *posValue in pilePos){
        CGPoint pos = [posValue CGPointValue];
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:pos withSpeed:0 angularSpeed:3 direction:arc4random()%2];
        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
        CGFloat ang = NJRandomAngle();
        if (_gameMode != NJGameModeBeginner) {
            [pile.physicsBody applyImpulse:CGVectorMake(NJWoodPileInitialImpluse*sinf(ang), NJWoodPileInitialImpluse*cosf(ang))];
        }
    }
}

- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"lakeMoonBG"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
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
        
        if (player.ninja.dying) {
            if (player.indicatorNode) {
                [player.indicatorNode removeFromParent];
                player.indicatorNode = nil;
            }
            
            if (player.item) {
                [player.item removeFromParent];
                player.item = nil;
            }
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
            
            if (!fileName) {
                [player.indicatorNode removeFromParent];
                player.indicatorNode = nil;
            }else if (!player.itemIndicatorAdded && fileName) {
                if (player.indicatorNode) {
                    [player.indicatorNode removeFromParent];
                }
                SKSpriteNode *itemIndicator = [SKSpriteNode spriteNodeWithImageNamed:fileName];
                itemIndicator.alpha = kIndicatorAlpha;
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
                                NJPile *pile = [self spawnAtRandomPileForNinja:YES];
                                pile.standingCharacter = p.ninja;
                                if (pile.itemHolded) {
                                    [(NSMutableArray*)self.items removeObject:pile.itemHolded];
                                    [pile.itemHolded removeFromParent];
                                }
                                [p.ninja resetToPosition:pile.position];
                                p.targetPile = nil;
                                p.jumpRequested = NO;
                                p.isJumping = NO;
                            }
                        }
                    }
                    
                    if (player.targetPile.isOnFire) {
                        NSLog(@"target on fire");
                        [player.ninja applyDamage:10];
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

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    // Update all players' ninjas.
    NSMutableArray *ninjasToRemove = [NSMutableArray new];
    for (NJNinjaCharacter *ninja in self.ninjas) {
        if (ninja.isDying) {
            [ninja.player.jumpTimerSprite removeAllActions];
            [ninja.player.jumpTimerSprite removeFromParent];
            [ninjasToRemove addObject:ninja];
        }
    }
    [self.ninjas removeObjectsInArray:ninjasToRemove];
    for (NJNinjaCharacter *ninja in self.ninjas) {
        [ninja updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    _pileDecreaseTime += timeSinceLast;
    if (shouldPileStartDecreasing && _pileDecreaseTime >= kPileDecreaseTimeInterval) {
        _pileDecreaseTime = 0;
        if ([_woodPiles count] > [_ninjas count]+1) {
            NSMutableArray *pilesToChoose = [NSMutableArray new];
            for (NJPile *pile in _woodPiles) {
                BOOL isFree = !pile.standingCharacter;
                for (NJPlayer *player in self.players) {
                    if (player.targetPile == pile) {
                        isFree = NO;
                        break;
                    }
                }
                if (isFree) {
                    [pilesToChoose addObject:pile];
                }
            }
            if ([pilesToChoose count] > 0) {
                int index = arc4random() % [pilesToChoose count];
                NJPile *pileToRemove = [pilesToChoose objectAtIndex:index];
                NJSpecialItem *itemToRemove = pileToRemove.itemHolded;
                [itemToRemove removeFromParent];
                [_items removeObject:itemToRemove];
                [pileToRemove removeFromParent];
                [_woodPiles removeObject:pileToRemove];
            }
        }
    }
    
    for (NJPile *pile in _woodPiles) {
        [pile updateWithTimeSinceLastUpdate:timeSinceLast];
        for (NJNinjaCharacter *ninja in _ninjas) {
            if (hypotf(ninja.position.x-pile.position.x, ninja.position.y-pile.position.y)<=CGRectGetWidth(pile.frame)/2 && !ninja.player.isJumping) {
                [pile addCharacterToPile:ninja];
                ninja.zRotation += pile.angleRotatedSinceLastUpdate;
                if (pile.rotateDirection == NJDirectionCounterClockwise) {
                    while (ninja.zRotation>=2*M_PI) {
                        ninja.zRotation -= 2*M_PI;
                    }
                } else {
                    while (ninja.zRotation<0) {
                        ninja.zRotation += 2*M_PI;
                    }
                }
                ninja.zRotation = normalizeZRotation(ninja.zRotation);
            }
        }
        
        if (pile.itemHolded) {
            pile.itemHolded.zRotation += pile.angleRotatedSinceLastUpdate;
            if (pile.rotateDirection == NJDirectionCounterClockwise) {
                while (pile.itemHolded.zRotation>=2*M_PI) {
                    pile.itemHolded.zRotation -= 2*M_PI;
                }
            } else {
                while (pile.itemHolded.zRotation<0) {
                    pile.itemHolded.zRotation += 2*M_PI;
                }
            }
            pile.itemHolded.zRotation = normalizeZRotation(pile.itemHolded.zRotation);
        }
        
        if (hypotf(pile.standingCharacter.position.x-pile.position.x, pile.standingCharacter.position.y-pile.position.y) > CGRectGetWidth(pile.frame)/2) {
            pile.standingCharacter = nil;
        }
        
        if (pile.itemHolded && ![self.items containsObject:pile.itemHolded]) {
            pile.itemHolded = nil;
        }
    }
    
    for (NJItemControl *control in _itemControls) {
        [control updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    
    for (NJSpecialItem *item in self.items){
        [item updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    
    for (NJPlayer *player in self.players) {
        if (player.itemUseRequested) {
            if (player.item != nil) {
                [player.ninja useItem:player.item];
            }
            player.itemIndicatorAdded = NO;
            player.itemUseRequested = NO;
            if (player.indicatorNode) {
                [player.indicatorNode removeFromParent];
            }
        }
    }
    
    for (NJHPBar *bar in _hpBars) {
        [bar updateHealthPoint];
    }
    
    int toSpawnItem = arc4random() % kNumOfFramesToSpawnItem;
    if (toSpawnItem==1) {
        [self addItem];
    }
    if (!isGameEnded) {
        isGameEnded = [self isGameEnded];
    }
}

- (void)didSimulatePhysics
{
    for (NJPile *pile in _woodPiles) {
        if (pile.standingCharacter && !pile.standingCharacter.player.isJumping) {
            pile.standingCharacter.position = pile.position;
            pile.standingCharacter.player.jumpTimerSprite.position = pile.position;
        }
        if (pile.itemHolded) {
            pile.itemHolded.position = pile.position;
        }
        if (pile.itemEffectOnPile) {
            pile.itemEffectOnPile.position = pile.position;
        }
    }
    for (NJItemControl *control in _itemControls) {
        control.itemHold.position = CGPointZero;
    }
}

#pragma mark - game ending test
- (bool)isGameEnded
{
    NSMutableArray *livingNinjas = [NSMutableArray array];
    for (int i=0; i<self.players.count; i++) {
        NJPlayer *player = self.players[i];
        if (!player.isDisabled && !player.ninja.dying){
            [livingNinjas addObject:[NSNumber numberWithInt:i]];
        }
    }
    if (livingNinjas.count <= 1) {
        if (!isGameEnded && livingNinjas.count == 1) {
            isGameEnded = YES;
            [self victoryAnimationToPlayer:[livingNinjas[0] integerValue]];
        }
        return true;
    } else {
        return false;
    }
}

- (void)victoryAnimationToPlayer:(NSInteger)index
{
    float angle = atan(1024/768)+0.1;
    _victoryBackground = [SKSpriteNode spriteNodeWithImageNamed:@"victory bg.png"];
    _victoryBackground.position = CGPointMake(1024/2, 768/2);
    SKSpriteNode *victoryLabel = [SKSpriteNode spriteNodeWithImageNamed:@"victory.png"];
    switch (index) {
        case 0:
            victoryLabel.zRotation = -angle;
            break;
        case 1:
            victoryLabel.zRotation = angle;
            break;
        case 2:
            victoryLabel.zRotation = M_PI-angle;
            break;
        case 3:
            victoryLabel.zRotation = M_PI+angle;
            break;
        default:
            break;
    }
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"Firework" ofType:@"sks"];
    SKEmitterNode *firework = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath1];
    firework.position = CGPointMake(-100, -100);
    firework.zRotation = victoryLabel.zRotation+M_PI/8;
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"FireworkRed" ofType:@"sks"];
    SKEmitterNode *fireworkRed = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath2];
    fireworkRed.position = CGPointMake(200, 0);
    fireworkRed.zRotation = victoryLabel.zRotation-M_PI/8;
    firework.userInteractionEnabled = NO;
    fireworkRed.userInteractionEnabled = NO;
    _continueButton = [SKSpriteNode spriteNodeWithImageNamed:@"continue.png"];
    _continueButton.name = @"continueButtonAfterVictory";
    _continueButton.zRotation = victoryLabel.zRotation;
    [_continueButton setScale:1/0.8];
    [self addChild:_victoryBackground];
    [_victoryBackground addChild:firework];
    [_victoryBackground addChild:fireworkRed];
    [_victoryBackground addChild:victoryLabel];
    [victoryLabel setScale:0.3];
    SKAction *scaleUp = [SKAction scaleBy:2 duration:0.5];
    [victoryLabel runAction:scaleUp];
    SKAction *shrinkDown = [SKAction scaleBy:0.8 duration:0.3];
    SKAction *shrinkUp = [SKAction scaleBy:1/0.8 duration:0.3];
    SKAction *shrink = [SKAction sequence:@[shrinkDown,shrinkUp]];
    SKAction *shrinkRepeatly = [SKAction repeatAction:shrink count:3];
    SKAction *sequenceScale = [SKAction sequence:@[scaleUp,shrinkRepeatly]];
    [victoryLabel runAction:sequenceScale completion:^{
        [_victoryBackground addChild:_continueButton];
    }];

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

#pragma mark - Event Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqual: @"continueButtonAfterVictory"]) {
        [_continueButton setScale:1.1];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqual: @"continueButtonAfterVictory"]) {
        SKAction *zoomOut = [SKAction scaleBy:0.1 duration:0.3];
        [_victoryBackground runAction:zoomOut completion:^{
            [_victoryBackground removeFromParent];
            [self restartGame];
        }];
    }
}

- (void)button:(NJButton *)button touchesBegan:(NSSet *)touches {
    button.colorBlendFactor = 0.0;
}

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches {
    button.colorBlendFactor = 1.0;
    NSArray *ninjas = self.ninjas;
    if ([ninjas count] < 1) {
        return;
    }
    
    NJPile *pile = [self woodPileToJump:button.player.ninja];
    if (pile && !button.player.isJumping && button.player.ninja.frozenCount == 0) {
        if (button.player.jumpCooldown >= kJumpCooldownTime) {
            button.player.jumpCooldown = 0;
            button.player.fromPile = button.player.targetPile;
            button.player.targetPile = pile;
            button.player.jumpRequested = YES;
            button.player.isJumping = YES;
            [button.player runJumpTimerAction];
        } else {
            NSLog(@"jump cooling down");
        }
    }
}

- (void)itemControl:(NJItemControl *)control touchesBegan:(NSSet *)touches
{
    control.colorBlendFactor = 0.0;
}

- (void)itemControl:(NJItemControl *)control touchesEnded:(NSSet *)touches
{
    control.colorBlendFactor = 1.0;
    NSArray *ninjas = self.ninjas;
    if ([ninjas count]<1) {
        return ;
    }
    // Use Item
    if (control.player.ninja.frozenCount == 0) {
        control.player.itemUseRequested = YES;
    }
}

- (NJPile *)woodPileToJump:(NJNinjaCharacter *)ninja
{
    NJPile *nearest = nil;
    for (NJPile *pile in _woodPiles) {
        if (!CGPointEqualToPointApprox(pile.position, ninja.position) && (!pile.standingCharacter || pile.standingCharacter.frozenCount==0)) {
            float dx = pile.position.x - ninja.position.x;
            float dy = pile.position.y - ninja.position.y;
            float zRotation = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(pile.position, ninja.position));
            if (zRotation < 0 && zRotation >= -M_PI/2) {
                zRotation += 2*M_PI;
            }
            float ninjaZRotation = ninja.zRotation;
            if (ninjaZRotation < 0) {
                float diff = ninjaZRotation + M_PI;
                ninjaZRotation = M_PI + diff;
            }
            float dist = hypotf(dx, dy);
            float radius = pile.size.width / 2;
            float angleSpaned = atan2f(radius,dist);
            if (zRotation-3*angleSpaned <= ninjaZRotation && zRotation+3*angleSpaned >= ninjaZRotation) {
                if (nearest == nil) {
                    nearest = pile;
                } else if (NJDistanceBetweenPoints(ninja.position, nearest.position)>NJDistanceBetweenPoints(ninja.position, pile.position)) {
                    nearest = pile;
                }
            }
        }
    }
    return nearest;
}

- (NJPile *)spawnAtRandomPileForNinja:(BOOL)isNinja
{
    NSMutableArray *array = [NSMutableArray new];
    for (NJPile *pile in _woodPiles) {
        BOOL isFree = YES;
        for (NJPlayer *player in self.players) {
            if (pile.standingCharacter || player.targetPile==pile) {
                isFree = NO;
                break;
            }
        }
        
        if (!isNinja && pile.itemHolded && [self.items containsObject:pile.itemHolded]) {
            isFree = NO;
        }
        
        if (isFree) {
            [array addObject:pile];
        }
    }
    if ([array count]<=0) {
        return nil;
    }
    int index = arc4random() % [array count];
    return ((NJPile*)array[index]);
}

#pragma mark - Shared Assets
+ (void)loadSceneAssets
{
    [NJNinjaCharacterNormal loadSharedAssets];
    [NJPlayer loadSharedAssets];
}

#pragma mark - Pause Game
- (void)addClickableArea
{
    _clickableArea = [[NJResponsibleBG alloc] init];
    _clickableArea.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:_clickableArea atWorldLayer:NJWorldLayerAboveCharacter];
    _clickableArea.delegate = self;
}

- (void)backgroundTouchesEnded:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    if (touchPoint.x>120 && touchPoint.x<1024-120 && touchPoint.y>120 && touchPoint.y<768-120) {
        [self pauseGame];
    }
}

- (void)pauseGame
{
    [self pauseWoodpiles];
    [self pauseItemUpdate];
    NJPausePanel *pausePanel = [[NJPausePanel alloc]init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    pausePanel.position = center;
    [self addChild:pausePanel];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(restartOrContinue:) name:@"actionAfterPause" object:nil];
    
    [music pause];
}

- (void)restartOrContinue:(NSNotification *)note
{
    NSUInteger actionIndex = [(NSNumber *)[note object]integerValue];
    if (!isSelectionInited && actionIndex == RESTART){
        [self restartGame];
    } else if(actionIndex == CONTINUE){
        [self continueItemUpdate];
        [self continueWoodpiles];
        [music play];
    } else if(actionIndex == BACK){
        NSNotificationCenter *nc  = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [self.delegate backToModeSelectionScene];
    }
}

- (void)resetMusic {
    if (music) {
        [music pause];
    }
    int musicIndex = 2;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicName[musicIndex] ofType:@"mp3"]];
    
    NSError *error;
    music = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    music.numberOfLoops = 100;
    [music play];
}

- (void)restartGame{
    isGameEnded = NO;
    for (int i=0; i<[self.players count]; i++) {
        NJPlayer *player = [self.players objectAtIndex:i];
        player.isDisabled = NO;
        [player.ninja reset];
        player.item = nil;
        [player.indicatorNode removeFromParent];
        player.indicatorNode = nil;
        player.targetPile = nil;
        player.fromPile = nil;
        player.isJumping = NO;
        player.jumpRequested = NO;
    }
    [self removeNinjas];
    [self resetItems];
    [self resetWoodPiles];
    [self initSelectionSystem];
    
    [self resetMusic];
    
}

- (void)removeNinjas
{
    for (NJNinjaCharacter *ninja in _ninjas) {
        [ninja removeFromParent];
        ninja.player.ninja = nil;
    }
    [_ninjas removeAllObjects];
}

- (void)continueWoodpiles
{
    for (NJPile *pile in self.woodPiles) {
        [pile setSpeed:3 direction:NJDiectionClockwise];
    }
}

- (void)continueItemUpdate
{
    
}

- (void)pauseWoodpiles
{
    for (NJPile *pile in self.woodPiles) {
        [pile setSpeed:0 direction:NJDiectionClockwise];
    }
}


- (void)pauseItemUpdate
{
    
}

- (void)resetItems
{
    for (NJSpecialItem *item in _items) {
        [item removeFromParent];
    }
    [_items removeAllObjects];
}

- (void)resetWoodPiles
{
    for (NJPile *pile in _woodPiles) {
        [pile removeFromParent];
    }
    [_woodPiles removeAllObjects];
    [self addWoodPiles];
}


#pragma mark - Selection System

- (void)initSelectionSystem{
    isSelectionInited = YES;
    shouldPileStartDecreasing = NO;
    NJSelectionButtonSystem *selectionSystem = [[NJSelectionButtonSystem alloc]init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    selectionSystem.position = center;
    [self addChild:selectionSystem];
    
    //add notification to actived players Index
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"activatedPlayerIndex" object:nil];
    [nc addObserver:self selector:@selector(activateSelectedPlayers:) name:@"activatedPlayerIndex" object:nil];
}

- (void) activateSelectedPlayers:(NSNotification *)note{
    isSelectionInited = NO;
    NSArray *activePlayerIndices = [note object];
    NSMutableArray *fullIndices = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
    for (NSNumber *index in activePlayerIndices) {
        [fullIndices removeObject:index];
    }
    
    for (NSNumber *index in fullIndices){ //inactivate unselected players
        //NSLog(@"activated %d",[index intValue]);
        int convertedIndex = [self convertIndex:[index intValue]];
        ((NJPlayer *)self.players[convertedIndex]).isDisabled = YES;
    }
    
    for (int i=0; i<kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        if(player.isDisabled){
            [_ninjas removeObject:player.ninja];
            [player.ninja removeFromParent];
        }
    }
    
    [self initHpBars];
    [self initButtonsAndItemControls];
    [self initCharacters];
    if (_gameMode != NJGameModeBeginner) {
        shouldPileStartDecreasing = YES;
    }
}

- (int)convertIndex:(int)index{
    switch (index) {
        case 0:
            return 3;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
        default:
            break;
    }
    [NSException raise:@"invalid index" format:@""];
    return -1;
}

- (void)inActivate{
    
}

#pragma mark - Delegate Methods

- (void)didBeginContact:(SKPhysicsContact *)contact {
    // Either bodyA or bodyB in the collision could be a character.
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[NJCharacter class]]) {
        [(NJCharacter *)node collidedWith:contact.bodyB];
    }
    
    // Check bodyB too.
    node = contact.bodyB.node;
    if ([node isKindOfClass:[NJCharacter class]]) {
        [(NJCharacter *)node collidedWith:contact.bodyA];
    }
}

- (NSArray *)getAffectedTargetsWithRange:(NJRange *)range
{
    NSMutableArray *affectedNinjas = [NSMutableArray array];
    for (NJPlayer *player in self.players) {
        if (!player.isDisabled) {
            if ([range isPointWithinRange:player.ninja.position]) {
                [affectedNinjas addObject:player.ninja];
            }
        }
    }
    
    return affectedNinjas;
}

- (NSArray *)getAffectedPilesWithRange:(NJRange *)range
{
    NSMutableArray *affectedPiles = [NSMutableArray array];
    for (NJPile *pile in _woodPiles) {
        if ([range isPointWithinRange:pile.position]) {
            [affectedPiles addObject:pile];
        }
    }
    return affectedPiles;
}

@end

//
//  NJLevelSceneWaterPark.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJNinjaCharacter.h"
#import "NJNinjaCharacterBoss.h"
#import "NJPile.h"
#import "NJButton.h"
#import "NJItemControl.h"
#import "NJHPBar.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"
#import "NJNinjaCharacterNormal.h"
#import "NJSelectionButtonSystem.h"
#import "NJ1V3SelectionButtonSystem.h"
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
#import "NJVictoryRestart.h"

@interface NJMultiplayerLayeredCharacterScene ()  <SKPhysicsContactDelegate, NJButtonDelegate,NJItemControlDelegate, NJBGclickingDelegate, NJScrollDelegate,NJCharacterDelegate>

@end

@implementation NJMultiplayerLayeredCharacterScene

{
    NJGameMode _gameMode;                           // game mode
    NSUInteger _bossIndex;                          // indicates boss player in 1 vs 3 mode. Index range {0,...,kNumPlayer-1}
    BOOL isSelectionInited;                         // indicates whether selection system has been initialized
    BOOL isFirstTimeInitialized;                    // indicates whether selection system initialized for the first time
    BOOL isGameEnded;                               // indicates whether the game ends
    BOOL shouldPileStartDecreasing;                 // indicates whether woodpiles should start decreasing periodically
    NSUInteger kNumberOfFramesToSpawnItem;          // rate for items to spawn
    BOOL hasBeenPaused;                             // indicates whether game is paused
}

#pragma mark - Initialization
/* Designated initializer. Initializes with a size and a game mode. */
- (instancetype)initWithSize:(CGSize)size mode:(NJGameMode)mode
{
    self = [self initWithSize:size];
    if (self) {
        _gameMode = mode;
        _world = [[SKNode alloc] init];
        [_world setName:GameWorld];
        [self initStore];
        [self initUsableItemTypes];
        [self initGameAttributeWithMode:mode];
        [self initLayers];
        [self initPlayers];
        [self addChild:_world];
        [self configurePhysicsBody];
        [self initItemFrequency];
        isSelectionInited = NO;
        isFirstTimeInitialized = YES;
        isGameEnded = NO;
        hasBeenPaused = NO;
        shouldPileStartDecreasing = NO;
        self.doAddItemRandomly = YES;
        [self buildWorld];
        if (mode != NJGameModeTutorial) {
            /* If it is not in tutorial mode, initializes the selection system and plays the music specific to non-tutorial mode. (Tutorial mode has its own catebory of background musics defined.) */
            self.musicName = [NSArray arrayWithObjects:kMusicPatrit, kMusicWater, kMusicShadow, kMusicSun, kMusicFunny, nil];
            [self resetMusic];
            [self initSelectionSystem];
        }
    }
    return self;
}

- (void)initStore
{
    _store = [[NJStore alloc] init];
}

// Retrieve items that are unlocked and store their product ids in the property _usableItemTypes
- (void)initUsableItemTypes
{
    _usableItemTypes = [NSMutableArray array];
    NSArray *arrayOfAllItemIds = [self getAllItemIds];
    
    for (ProductId *pId in arrayOfAllItemIds){
        if ([_store isProductUnlocked:pId]) {
            NJItemType itemType = [self determineItemTypeFromProductId:pId];
            if (itemType >= 0) {
                [_usableItemTypes addObject:[NSNumber numberWithInt:itemType]];
            }
        }
    }
}

// Return product ids for all special items, regardless of whether it has been unlocked or not
- (NSArray *)getAllItemIds
{
    NSArray *itemIds = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProductIdItem" ofType:@"plist"]];
    return itemIds;
}

- (NJItemType)determineItemTypeFromProductId:(ProductId *)pId
{
    if ([pId isEqualToString:kIceScrollProductId]) {
        return NJItemIceScroll;
    }else if([pId isEqualToString:kFireScrollProductId]){
        return NJItemFireScroll;
    }else if([pId isEqualToString:kWindScrollProductId]){
        return NJItemWindScroll;
    }else if([pId isEqualToString:kThunderScrollProductId]){
        return NJItemThunderScroll;
    }else if([pId isEqualToString:kMedikitProductId]){
        return NJItemMedikit;
    }else if([pId isEqualToString:kMineProductId]){
        return NJItemMine;
    }else if([pId isEqualToString:kShurikenProductId]){
        return NJItemShuriken;
    }else{
        return -1;
    }
}

- (void)initGameAttributeWithMode:(NJGameMode)mode
{
    self.attribute = [NJGameAttribute attributeWithMode:mode];
}

/* Intializes different layers in game world. */
- (void)initLayers
{
    _layers = [NSMutableArray arrayWithCapacity:kWorldLayerCount];
    for (int i = 0; i < kWorldLayerCount; i++) {
        SKNode *layer = [[SKNode alloc] init];
        layer.zPosition = i - kWorldLayerCount;
        [_world addChild:layer];
        [_layers addObject:layer];
    }
}

/* Intializes players in the game. */
- (void)initPlayers
{
    _players = [[NSMutableArray alloc] initWithCapacity:kNumPlayers];
    for (int i=0; i<kNumPlayers ; i++) {
        NJPlayer *player = [[NJPlayer alloc] init];
        if (_gameMode == NJGameModeOneVsThree) {
            if (i == _bossIndex) {
                player.teamId = NJTeamOne;
            }else{
                player.teamId = NJTeamTwo;
            }
        }else{
            player.teamId = (NJTeamId)i;
        }
        [_players addObject:player];
    }
}

/* Initializes frequency of occurrences for special items according to the mode selected. */
- (void)initItemFrequency
{
    kNumberOfFramesToSpawnItem = [self.attribute getNumberOfFramesToSpawnItem];
}

/* Configures physics body for the scene. */
- (void)configurePhysicsBody
{
    UIBezierPath *path = [self drawGameAreaBoarder];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path.CGPath];
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.friction = 0.0;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.restitution = 1.0;
}

/* Initializes the HP Bars for each player. This is a node where the amount of health points of a ninja is reflected on the screen. */
- (void)initHpBars
{
    if (!_hpBars) {
        _hpBars = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    for (int i=0; i < kNumPlayers; i++) {
        CGPoint position = [self determinePositionOfHpBarIndexedBy:i];
        NJPlayer *player = self.players[i];
        if ([_hpBars count] < kNumPlayers) {
            NJHPBar *bar = [NJHPBar hpBarWithPosition:position andPlayer:self.players[i]];
            float angle = i * M_PI / 2 - M_PI / 2;
            bar.zRotation = angle;
            [_hpBars addObject:bar];
        }
        if (!player.isDisabled) {
            // Only add hp bar for players that are enabled
            if (!((NJHPBar *)_hpBars[i]).parent) {
                [self addChild:_hpBars[i]];
            }
        }else{
            [(NJHPBar *)_hpBars[i] removeFromParent];
        }
    }
}

/* Initializes all characters in the game. */
- (void)initCharacters
{
    if (!_ninjas) {
        _ninjas = [NSMutableArray array];
    }
    [_ninjas removeAllObjects];
    for (int index=0; index<4; index++) {
        NJPlayer *player = self.players[index];
        if (!player.isDisabled) {
            player.shouldBlendCharacter = YES;
            if (index == _bossIndex && _gameMode == NJGameModeOneVsThree) {
                player.shouldBlendCharacter = NO;
            }
            NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
            [self addNode:ninja.shadow atWorldLayer:NJWorldLayerBelowCharacter];
            NJPile *pile = [self spawnAtRandomPileForNinja:YES];
            pile.standingCharacter = ninja;
            ninja.position = pile.position;
        }else if(player.ninja){
            [_ninjas removeObject:player.ninja];
            [player.ninja removeFromParent];
        }
    }
}

/* Initializes jump buttons and item control buttons in the scene. */
- (void)initButtonsAndItemControls
{
    double xDiff = 40, yDiff=90;
    if (!_itemControls) {
        _itemControls = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    for (int i=0; i<kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        if ([_itemControls count]<kNumPlayers) {
            NJItemControl *control = [[NJItemControl alloc] initWithImageNamed:NJButtonItemControl];
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
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    //configure item control buttons for players.
    [self configureControlButton:_itemControls[0] ForPlayerIndex:0 atPosition:CGPointMake(0+xDiff, 0+yDiff) withRotation:-M_PI/4];
    [self configureControlButton:_itemControls[1] ForPlayerIndex:1 atPosition:CGPointMake(width-yDiff, xDiff) withRotation:M_PI/4];
    [self configureControlButton:_itemControls[2] ForPlayerIndex:2 atPosition:CGPointMake(width-xDiff, height-yDiff) withRotation:3*M_PI/4];
    [self configureControlButton:_itemControls[3] ForPlayerIndex:3 atPosition:CGPointMake(yDiff, height-xDiff) withRotation:-3*M_PI/4];
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:kNumPlayers];
    }
    for (int i = 0; i < kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        if ([_buttons count]<kNumPlayers) {
            NJButton *button = [[NJButton alloc] initWithImageNamed:NJButtonJump];
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
    //configure jump buttons for players
    [self configureControlButton:_buttons[0] ForPlayerIndex:0 atPosition:CGPointMake(yDiff, xDiff) withRotation:-M_PI/4];
    [self configureControlButton:_buttons[1] ForPlayerIndex:1 atPosition:CGPointMake(width-xDiff, yDiff) withRotation:M_PI/4];
    [self configureControlButton:_buttons[2] ForPlayerIndex:2 atPosition:CGPointMake(width-yDiff, height-xDiff) withRotation:3*M_PI/4];
    [self configureControlButton:_buttons[3] ForPlayerIndex:3 atPosition:CGPointMake(xDiff, height-yDiff) withRotation:-3*M_PI/4];
}

/* Configures a jump or item control button. */
- (void)configureControlButton:(SKSpriteNode *)button ForPlayerIndex:(int)index atPosition:(CGPoint)position withRotation:(CGFloat)rotation
{
    SKSpriteNode *btn;
    if ([button isKindOfClass:[NJButton class]]) {
        btn = _buttons[index];
        switch (index) {
            case 0:
                ((NJButton*)btn).player.color = kNinjaOneColor;
                break;
            case 1:
                ((NJButton*)btn).player.color = kNinjaTwoColor;
                break;
            case 2:
                ((NJButton*)btn).player.color = kNinjaThreeColor;
                break;
            case 3:
                ((NJButton*)btn).player.color = kNinjaFourColor;
                break;
            default:
                break;
        }
    } else {
        btn = _itemControls[index];
    }
    btn.position = position;
    btn.zRotation = rotation;
    switch (index) {
        case 0:
            btn.color = kNinjaOneColor;
            break;
        case 1:
            btn.color = kNinjaTwoColor;
            break;
        case 2:
            btn.color = kNinjaThreeColor;
            break;
        case 3:
            btn.color = kNinjaFourColor;
            break;
        default:
            break;
    }
    btn.colorBlendFactor = kButtonColorBlendFactor;
}

#pragma mark - Layers
/* Adds a node on a specific layer in the world. */
- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

/* Adds an effect node on a specific layer in the world. */
- (void)addEffect:(NJItemEffect*)effect
{
    [self addNode:effect atWorldLayer:NJWorldLayerCharacter];
}

#pragma mark - Heroes and Players
/* Adds a ninja character for a player. */
- (NJNinjaCharacter *)addNinjaForPlayer:(NJPlayer *)player
{
    if (player.ninja && !player.ninja.dying) {
        [player.ninja removeFromParent];
        [player.indicatorNode removeFromParent];
    }
    
    NJNinjaCharacter *ninja = nil;
    
    if (_gameMode == NJGameModeOneVsThree) {
        if (_bossIndex<[self.players count]) {
            NJPlayer *bossPlayer = [self.players objectAtIndex:_bossIndex];
            if (bossPlayer == player) {
                ninja = [[NJNinjaCharacterBoss alloc ] initWithTextureNamed:kBossNinjaImageName atPosition:CGPointZero withPlayer:player delegate:self];
            }
        }
    }
    if (!ninja) {
        ninja = [[NJNinjaCharacterNormal alloc] initWithTextureNamed:kNinjaImageName atPosition:CGPointZero withPlayer:player delegate:self];
    }
    
    if (ninja) {
        [ninja render];
        [(NSMutableArray *)self.ninjas addObject:ninja];
    }
    if (player.shouldBlendCharacter) {
        ninja.color = player.color;
        ninja.colorBlendFactor = kNinjaColorBlendFactor;
    }
    player.ninja = ninja;
    
    return ninja;
}

#pragma mark - World Building
- (void)buildWorld {
    // Configure physics for the world.
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f); // no gravity
    self.physicsWorld.contactDelegate = self;
    
    [self addBackground];
    [self addWoodPiles];
    [self addClickableArea];
}

- (void)addWoodPiles
{
    if (!_woodPiles) {
        _woodPiles = [NSMutableArray array];
    }
    
//    CGFloat r= 230.0f;
    NSArray *pilePosDict = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InitialDistributionOfWoodpilesIPad" ofType:@"plist"]];
    NSMutableArray *pilePos = [NSMutableArray array];
    for (int i=0; i<[pilePosDict count]; i++) {
        NSDictionary *dict = (NSDictionary *)[pilePosDict objectAtIndex:i];
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake([((NSNumber *)[dict objectForKey:@"x"]) integerValue], [((NSNumber *)[dict objectForKey:@"y"]) integerValue])];
        [pilePos addObject:point];
    }
    
//    NSArray *pilePos = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:CGPointMake(350, 220)], [NSValue valueWithCGPoint:CGPointMake(1024-r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(512, 500)], [NSValue valueWithCGPoint:CGPointMake(400, 350)], [NSValue valueWithCGPoint:CGPointMake(300, 100)], [NSValue valueWithCGPoint:CGPointMake(650, 350)], [NSValue valueWithCGPoint:CGPointMake(850, 400)], [NSValue valueWithCGPoint:CGPointMake(200, 300)], [NSValue valueWithCGPoint:CGPointMake(260, 410)], [NSValue valueWithCGPoint:CGPointMake(550, 400)], [NSValue valueWithCGPoint:CGPointMake(700, 610)], [NSValue valueWithCGPoint:CGPointMake(750, 150)], nil];
    //add in the spawn pile of ninjas
    for (NSValue *posValue in pilePos){
        CGPoint pos = [posValue CGPointValue];
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:NJWoodPileImageName atPosition:pos withSpeed:0 angularSpeed:3 direction:arc4random()%2];
        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
        CGFloat ang = NJRandomAngle();
        if ([_attribute shouldWoodpileMove]) {
            [pile.physicsBody applyImpulse:CGVectorMake(NJWoodPileInitialImpluse*sinf(ang), NJWoodPileInitialImpluse*cosf(ang))];
        }
    }
}

- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:kBackgroundFileName];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
}

#pragma mark - Items
- (void)addItem{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    NJPile *pile = [self spawnAtRandomPileForNinja:NO];
    if (!pile || [self.items count]>=3 ) {
        return;
    }
    CGPoint position = pile.position;
    NJSpecialItem *item;
    if (_gameMode == NJGameModeBeginner) {
        item = [self generateRandomItemForBeginnerMode];
    } else {
        item = [self generateRandomItem];
    }
    if (item != nil) {
        item.myParent = self;
        pile.itemHolded = item;
        item.position = position;
        item.itemShadow.position = position;
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [self addNode:item.itemShadow atWorldLayer:NJWorldLayerBelowCharacter];
        [_items addObject:item];
    }
}

- (NJSpecialItem *)generateRandomItemForBeginnerMode{
    int index = arc4random() % 2;
    NJSpecialItem *item;
    CGPoint position = CGPointZero;
    switch (index) {
        case 0:
            item = [NJMedikit itemAtPosition:position];
            break;
        case 1:
            item = [NJShuriken itemAtPosition:position];
            break;
        default:
            break;
    }
    return item;
}

- (NJSpecialItem *)generateRandomItem
{
    int randNum = arc4random() % ([_usableItemTypes count]);
    NJItemType itemType = (NJItemType)[((NSNumber *)[_usableItemTypes objectAtIndex:randNum]) integerValue];
    NJSpecialItem *item;

    CGPoint position = CGPointZero;
    switch (itemType) {
        case NJItemThunderScroll:
            item = [NJThunderScroll itemAtPosition:position delegate:self];
            break;
            
        case NJItemWindScroll:
            item = [NJWindScroll itemAtPosition:position delegate:self];
            break;
            
        case NJItemIceScroll:
            item = [NJIceScroll itemAtPosition:position delegate:self];
            break;
            
        case NJItemFireScroll:
            item = [NJFireScroll itemAtPosition:position delegate:self];
            break;
            
        case NJItemMedikit:
            item = [NJMedikit itemAtPosition:position];
            break;
        
        case NJItemMine:
            item = [NJMine itemAtPosition:position];
            break;
        
        case NJItemShuriken:
            item = [NJShuriken itemAtPosition:position];
            break;
            
        default:
            break;
    }
    if (item) {
        item.myParent = self;
    }
    return item;
}

#pragma mark - Loop Update
- (void)update:(NSTimeInterval)currentTime {
    if (!hasBeenPaused) {
        // Handle time delta.
        // If we drop below 60fps, we still want everything to move the same distance.
        NSTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > 1) { // more than a second since last update
            timeSinceLast = kMinTimeInterval;
            self.lastUpdateTimeInterval = currentTime;
        }
        
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
        [self removeDyingNinjas];
        [self updatePlayers];
        [self updateHpBars];
        [self spawnNewItems];
        [self applyImpulseToSlowWoodpiles];
        [self removePickedUpItem];
        [self removeOutdatedItem];
        [self checkGameEnded];
    }
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    [self updateNinjaStatesSinceLastUpdate:timeSinceLast];
    [self decreasePilesSinceLastUpdate:timeSinceLast];
    [self updateWoodpilesSinceLastUpdate:timeSinceLast];
    [self updateItemControlsSinceLastUpdate:timeSinceLast];
    [self updateItemsSinceLastUpdate:timeSinceLast];
    [self updatePlayersSinceLastUpdate:timeSinceLast];
}

/* Forces the objects with wrong position (due to physics world) back to the right position */
- (void)didSimulatePhysics
{
    for (NJPile *pile in _woodPiles) {
        if (pile.standingCharacter && !pile.standingCharacter.player.isJumping) {
            pile.standingCharacter.position = pile.position;
            pile.standingCharacter.shadow.position = pile.position;
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

#pragma mark - Game Ending Test
- (bool)isGameEnded
{
    NSMutableArray *livingNinjas = [NSMutableArray array];
    for (int i=0; i<self.players.count; i++) {
        NJPlayer *player = self.players[i];
        if (!player.isDisabled && !player.ninja.dying){
            [livingNinjas addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    if (_gameMode == NJGameModeOneVsThree) {
        if (!isGameEnded && ((NJPlayer *)self.players[_bossIndex]).ninja.isDying){
            isGameEnded = YES;
            _isBossLost = YES;
            [self victoryAnimationToPlayer:_bossIndex];
            return YES;
        } else {
            if (!isGameEnded && [livingNinjas count] == 1) {
                isGameEnded = YES;
                [self victoryAnimationToPlayer:_bossIndex];
                return YES;
            }else{
                return NO;
            }
        }
    }else{
        if (livingNinjas.count <= 1) {
            if (!isGameEnded && livingNinjas.count == 1) {
                isGameEnded = YES;
                [self victoryAnimationToPlayer:[livingNinjas[0] integerValue]];
            }
            return YES;
        } else{
            return NO;
        }
    }
    
    return NO;
}

- (void)victoryAnimationToPlayer:(NSInteger)index
{
    _victoryBackground = [SKSpriteNode spriteNodeWithImageNamed:@"victory bg"];
    _victoryBackground.position = CGPointMake(CGRectGetMidX(FRAME), CGRectGetMidY(FRAME));
//    SKSpriteNode *victoryLabel = [_attribute getVictoryLabelForWinnerIndex:index];
    SKSpriteNode *victoryLabel;
    float angle = atan(FRAME.size.width/FRAME.size.height)+0.1;
    
    if (_gameMode == NJGameModeOneVsThree) {
        if (_isBossLost) {
            victoryLabel = [SKSpriteNode spriteNodeWithImageNamed:@"bossLoss"];
        }else{
            victoryLabel = [SKSpriteNode spriteNodeWithImageNamed:@"bossWin"];
        }
    }else{
        victoryLabel = [SKSpriteNode spriteNodeWithImageNamed:@"victory"];
    }
    
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
        [_victoryBackground runAction:[SKAction scaleTo:0.0f duration:0.5] completion:^{
            [_victoryBackground removeFromParent];
        }];
        [self presentVictoryRestartScene];
    }];
}

- (void)presentVictoryRestartScene
{
    NJVictoryRestart *victoryRestart = [[NJVictoryRestart alloc] init];
    victoryRestart.position = CGPointMake(FRAME.size.width/2, FRAME.size.height/2);
    victoryRestart.xScale = 0.0f;
    victoryRestart.yScale = 0.0f;
    [self addChild:victoryRestart];
    [victoryRestart runAction:[SKAction scaleTo:1.0f duration:0.5]];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(restartOrContinue:) name:@"actionAfterPause" object:nil];
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
    [NJNinjaCharacterNormal loadSharedAssets];
    [NJNinjaCharacterBoss loadSharedAssets];
    [NJPlayer loadSharedAssets];
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

- (void)showPausePanel
{
    NJPausePanel *pausePanel = [[NJPausePanel alloc]init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    pausePanel.position = center;
    
    [self addChild:pausePanel];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(restartOrContinue:) name:@"actionAfterPause" object:nil];
}

- (void)pauseGame
{
    self.physicsWorld.speed = 0;
    hasBeenPaused = YES;
    [self.music pause];
    
    [self showPausePanel];
}

- (void)restartOrContinue:(NSNotification *)note
{
    NSUInteger actionIndex = [(NSNumber *)[note object] integerValue];
    if (!isSelectionInited && actionIndex == RESTART){
        [self restartGame];
    } else if(actionIndex == RESUME){
        hasBeenPaused = NO;
        self.physicsWorld.speed = 1;
        [_music play];
    } else if(actionIndex == HOME){
        NSNotificationCenter *nc  = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [self.music pause];
        [self.delegate backToModeSelectionScene];
    }
}

- (void)resetMusic {
    if (self.music) {
        [self.music pause];
    }
    int musicIndex = arc4random() % [self.musicName count];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.musicName[musicIndex] ofType:@"mp3"]];
    
    NSError *error;
    self.music = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.music.numberOfLoops = 100;
    [self.music play];
}

- (void)restartGame{
    isGameEnded = NO;
    
    for (int i=0; i<[self.players count]; i++) {
        NJPlayer *player = [self.players objectAtIndex:i];
        player.isDisabled = NO;
        [player.ninja reset];
        player.item = nil;
        [player.indicatorNode removeFromParent];
        [player.ninja.shadow removeFromParent];
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

- (void)resetItems
{
    for (NJSpecialItem *item in _items) {
        [item removeFromParent];
        [item.itemShadow removeFromParent];
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
    hasBeenPaused = YES;
    self.physicsWorld.speed=0;
    
    NJSelectionButtonSystem *selectionSystem;
    if (_gameMode == NJGameModeOneVsThree) {
        selectionSystem = [[NJ1V3SelectionButtonSystem alloc] init];
    } else {
        selectionSystem = [[NJSelectionButtonSystem alloc] init];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    selectionSystem.position = center;
    [self addChild:selectionSystem];
    
    //add notification to actived players Index
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:kNotificationPlayerIndex object:nil];
    [nc addObserver:self selector:@selector(activateSelectedPlayers:) name:kNotificationPlayerIndex object:nil];
}

- (void)activateSelectedPlayers:(NSNotification *)note{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:kNotificationPlayerIndex object:nil];
    isSelectionInited = NO;
    
    NSArray *activePlayerIndices = [note object];
    if (_gameMode==NJGameModeOneVsThree) {
        _bossIndex = [[activePlayerIndices firstObject] integerValue];
    }
    NSMutableArray *fullIndices = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
    for (NSNumber *index in activePlayerIndices) {
        [fullIndices removeObject:index];
    }
    
    for (NSNumber *index in fullIndices){ //inactivate unselected players
        ((NJPlayer *)self.players[[index intValue]]).isDisabled = YES;
    }
    
    for (int i=0; i<kNumPlayers; i++) {
        NJPlayer *player = (NJPlayer *)self.players[i];
        if(player.isDisabled){
            [_ninjas removeObject:player.ninja];
            [player.ninja removeFromParent];
        }
    }
    
    [self activateSelectedPlayersWithPreSetting];
}

- (void) activateSelectedPlayersWithPreSetting
{
    [self initHpBars];
    [self initButtonsAndItemControls];
    [self initCharacters];
    shouldPileStartDecreasing = [_attribute shouldPileDecrease];
    if(_gameMode != NJGameModeTutorial){
        [self fireCountdown];
    }
}

//fire the countdown animation before starting game
-(void)fireCountdown {
    hasBeenPaused = NO;
    CGRect frame = FRAME;
    
    SKSpriteNode *coverLayer = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:frame.size];
    coverLayer.position = CGPointMake(frame.size.width/2, frame.size.height/2);
    coverLayer.alpha = 0.0;
    coverLayer.userInteractionEnabled = YES;
    
    SKSpriteNode *countdown1 = [SKSpriteNode spriteNodeWithImageNamed:@"countdown1"];
    SKSpriteNode *countdown2 = [SKSpriteNode spriteNodeWithImageNamed:@"countdown2"];
    SKSpriteNode *countdown3 = [SKSpriteNode spriteNodeWithImageNamed:@"countdown3"];
    SKSpriteNode *countdown = [[SKSpriteNode alloc]init];
    
    [self addChild:coverLayer];
    [self addChild:countdown];
    
    countdown.position = CGPointMake(FRAME.size.width/2, FRAME.size
                                     .height/2);
    NSArray *countdownSeries = [NSArray arrayWithObjects:countdown3, countdown2, countdown1, nil];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *wait = [SKAction fadeInWithDuration:0.4];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
    SKAction *removeNode = [SKAction removeFromParent];
    
    for(int i=0;i<3;i++){
        SKSpriteNode *countdownNum = countdownSeries[i];
        countdownNum.alpha = 0.0;
        [countdown addChild:countdownNum];
        SKAction *pending = [SKAction waitForDuration:i];
        SKAction *appear = [SKAction sequence:@[pending,fadeIn,wait,fadeOut,removeNode]];
        [countdownNum runAction:appear];
    }
    
    [self performSelector:@selector(startGame:) withObject:coverLayer afterDelay:3.0];
}

- (void)startGame:(SKSpriteNode *)cover
{
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
    SKAction *wait = [SKAction fadeInWithDuration:0.3];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.1];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *appear = [SKAction sequence:@[fadeIn,wait,fadeOut,removeNode]];
    
    SKSpriteNode *startNote = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
    startNote.position = CGPointMake(1024/2, 768/2);
    [self addChild:startNote];
    
    [startNote runAction:appear completion:^{
        [cover removeFromParent];
    }];
    self.physicsWorld.speed = 1.0;
}

#pragma mark - Auxiliary Methods
/* Returns the game boarder. */
- (UIBezierPath *)drawGameAreaBoarder
{
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(kGameBoardRadius, 0)];
    [path addArcWithCenter:CGPointMake(0, 0) radius:kGameBoardRadius startAngle:0 endAngle:M_PI*3/2 clockwise:YES];
    [path addLineToPoint:CGPointMake(0, height-kGameBoardRadius)];
    [path addArcWithCenter:CGPointMake(0, height) radius:kGameBoardRadius startAngle:M_PI/2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(width-kGameBoardRadius, height)];
    [path addArcWithCenter:CGPointMake(width, height) radius:kGameBoardRadius startAngle:M_PI endAngle:M_PI/2 clockwise:YES];
    [path addLineToPoint:CGPointMake(width, kGameBoardRadius)];
    [path addArcWithCenter:CGPointMake(width, 0) radius:kGameBoardRadius startAngle:M_PI*3/2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(kGameBoardRadius, 0)];
    [path closePath];
    return path;
}

/* Determines the target wood pile according to the ninja's facing direction. If there is no target wood pile in the corresponding direction, return nil. */
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

/* Determines a random pile among the free ones for ninja or item to spawn at. Returns nil if no free ones available, return nil. */
- (NJPile *)spawnAtRandomPileForNinja:(BOOL)isNinja
{
    NSMutableArray *array = [NSMutableArray array];
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


/* Removes Ninjas that are dying from being rendered in MScene and disables the control. */
- (void)removeDyingNinjas
{
    NSMutableArray *ninjasToRemove = [NSMutableArray new];
    for (NJNinjaCharacter *ninja in self.ninjas) {
        if (ninja.isDying) {
            [ninja.player.jumpTimerSprite removeAllActions];
            [ninja.player.jumpTimerSprite removeFromParent];
            [ninjasToRemove addObject:ninja];
        }
    }
    [self.ninjas removeObjectsInArray:ninjasToRemove];
}

/* Triggers the update loop in NJCharacter instances, which resolves the character-level animations requested inside NJCharacter and also generates random item for boss player, if in 1V3 mode. */
- (void)updateNinjaStatesSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJNinjaCharacter *ninja in self.ninjas) {
        [ninja updateWithTimeSinceLastUpdate:timeSinceLast];
        if ([ninja isKindOfClass:[NJNinjaCharacterBoss class]]) {
            if (((NJNinjaCharacterBoss*)ninja).needsAddItem) {
                ((NJNinjaCharacterBoss*)ninja).needsAddItem = NO;
                if (ninja.player.item) {
                    continue;
                }
                NJSpecialItem *item = nil;
                while (item == nil) {
                    item = [self generateRandomItem];
                    if ([item isKindOfClass:[NJMedikit class]]) {
                        item = nil;
                    }
                }
                if (item) {
                    ninja.player.item = item;
                }
            }
        }
    }
}

/* Decreases the number of woodpiles, if necessary according to the result of a randome number generator. */
- (void)decreasePilesSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
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
                [itemToRemove.itemShadow removeFromParent];
                [_items removeObject:itemToRemove];
                [pileToRemove removeFromParent];
                [_woodPiles removeObject:pileToRemove];
            }
        }
    }
}

/* Update the state of each woodpiles since last update. Checks if there is any item or ninja on it and if yes, add it to the corresponding property of a pile. */
- (void)updateWoodpilesSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJPile *pile in _woodPiles) {
        [pile updateWithTimeSinceLastUpdate:timeSinceLast];
        
        // Updates the position ad zrotation of the woodpile's standing character to be the same as the woodpile
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
        
        // If there is any item on the pile, update the items position and zrotation to be the same with the woodpile
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
        
        // Remove the its standing character reference if the character has jumped away from the woodpile
        if (hypotf(pile.standingCharacter.position.x-pile.position.x, pile.standingCharacter.position.y-pile.position.y) > CGRectGetWidth(pile.frame)/2) {
            pile.standingCharacter = nil;
        }
        
        if (pile.itemHolded && ![self.items containsObject:pile.itemHolded]) {
            pile.itemHolded = nil;
        }
    }
}

/* Update the item control reflected in the user interface. */
- (void)updateItemControlsSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJItemControl *control in _itemControls) {
        [control updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

/* Triggers the update loop in each of the items. */
- (void)updateItemsSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJSpecialItem *item in self.items){
        [item updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

/* Checks if there are any time-independent actions requested by the players. If YES, perform those actions. */
- (void)updatePlayers
{
    for (NJPlayer *player in self.players) {
        if (player.itemUseRequested) {
            if (player.item != nil) {
                // prevent player from using mine when jumping
                if (![player.item isKindOfClass:[NJMine class]] || !player.isJumping) {
                    [player.ninja useItem:player.item];
                }
            }
            player.itemIndicatorAdded = NO;
            player.itemUseRequested = NO;
            if (player.indicatorNode) {
                [player.indicatorNode removeFromParent];
            }
        }
    }
}

/* Updates the mask of the Health Point Bars to reflect the correct amount of health points left for each player. */
- (void)updateHpBars
{
    for (NJHPBar *bar in _hpBars) {
        [bar updateHealthPoint];
    }
}

/* Decides whether to spawn new items on screen, and if yes, spawn a random new item at a random woodpile selected. */
- (void)spawnNewItems
{
    int toSpawnItem = arc4random() % kNumberOfFramesToSpawnItem;
    if (toSpawnItem==1 && self.doAddItemRandomly) {
        [self addItem];
    }
}

/* Checks if the game has ended and if yes, announce the winner. */
- (void)checkGameEnded
{
    if (!isGameEnded) {
        isGameEnded = [self isGameEnded];
    }
}

/* Checks if there is any piles that is too slow and if there is any, apply some impulse to speed them up. */
- (void)applyImpulseToSlowWoodpiles
{
    if ([_attribute shouldApplyImpulesToSlowWoodpiles]) {
        for (NJPile *pile in _woodPiles) {
            float dx = pile.physicsBody.velocity.dx;
            float dy = pile.physicsBody.velocity.dy;
            float xSign = dx > 0? 1:-1;
            float ySign = dy > 0? 1:-1;
            
            if (fabs(dx) < MINIMUM_VELOCITY) {
                [pile.physicsBody applyImpulse:CGVectorMake(2*xSign, 0)];
            }
            
            if (fabs(dy) < MINIMUM_VELOCITY) {
                [pile.physicsBody applyImpulse:CGVectorMake(0, 2*ySign)];
            }
        }
    }
}

/* Removes items from being rendered once picked up. */
- (void)removePickedUpItem
{
    NSMutableArray *itemsToRemove = [NSMutableArray array];
    for (NJSpecialItem *item in self.items){
        item.itemShadow.position = item.position;
        if (item.isPickedUp) {
            [item.itemShadow removeFromParent];
            [itemsToRemove addObject:item];
        }
    }
    
    for (id item in itemsToRemove){
        [(NSMutableArray*)self.items removeObject:item];
    }
}

/* Removes items that has been existing longer than its maximum lifetime. */
- (void)removeOutdatedItem
{
    NSMutableArray *itemsToRemove = [NSMutableArray array];
    for (NJSpecialItem *item in self.items){
        if (item.lifeTime > kMaxItemLifeTime) {
            [item.itemShadow removeFromParent];
            [itemsToRemove addObject:item];
        }
    }
    for (NJSpecialItem *item in itemsToRemove){
        [item removeFromParent];
        [item.itemShadow removeFromParent];
        [(NSMutableArray*)self.items removeObject:item];
    }
}

/* Updates the state of all players since last update. */
- (void)updatePlayersSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJPlayer *player in self.players) {
        if ((id)player == [NSNull null]) {
            continue;
        }
        NJNinjaCharacter *ninja = nil;
        if ([self.ninjas count] > 0){
            ninja = player.ninja;
        }
        
        if (player.ninja.dying) {
            // If a ninja is dying, remove all items, indicator nodes and shadows attached to the ninja
            if (player.indicatorNode) {
                [player.indicatorNode removeFromParent];
                player.indicatorNode = nil;
            }
            
            if (player.item) {
                [player.item removeFromParent];
                if (player.item.itemShadow) {
                    [player.item.itemShadow removeFromParent];
                }
                player.item = nil;
            }
            [player.ninja.shadow removeFromParent];
        }
        
        if (player.item) {
            // If the player is holding any item and no indicator node has been added yet, add an indicator node to the player so as to indicate the range where the item being held can affect
            NSString *fileName;
            if ([player.item isKindOfClass:[NJThunderScroll class]]) {
                fileName = kThunderIndicator;
            }else if([player.item isKindOfClass:[NJWindScroll class]]){
                fileName = kWindIndicator;
            }else if([player.item isKindOfClass:[NJFireScroll class]]){
                fileName = kFireIndicator;
            }else if([player.item isKindOfClass:[NJIceScroll class]]){
                fileName = kIceIndicator;
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
                [self addNode:itemIndicator atWorldLayer:NJWorldLayerGround];
                player.indicatorNode = itemIndicator;
                player.itemIndicatorAdded = YES;
            }
        }else{
            // If the player is not holding any item, remove its indicator node
            player.indicatorNode = nil;
        }
        
        if (player.indicatorNode) {
            // Update the indicator node to have the same position and zRotation as the player
            player.indicatorNode.position = player.ninja.position;
            player.indicatorNode.zRotation = player.ninja.zRotation;
        }
        
        if (![ninja isDying]) {
            ninja.position = CGPointApprox(ninja.position);
            [self resolveSpecialItemEffectsForCharacter:ninja sinceLastUpdate:timeSinceLast];
            
            if (player.jumpRequested) {
                [self resolveJumpRequestForPlayer:player sinceLastUpdate:timeSinceLast];
            } else {
                player.jumpCooldown += timeSinceLast;
            }
        }
    }
}

/* Resolve all effects applied to the character by special items. */
- (void)resolveSpecialItemEffectsForCharacter:(NJCharacter *)character sinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    if (character.frozenCount > 0) {
        character.frozenCount -= timeSinceLast;
    }
    if (character.frozenCount < 0) {
        character.frozenCount = 0;
        [character.frozenEffect removeFromParent];
        character.frozenEffect = nil;
    }
}

/* Resolve jumping requests for the player specified. */
- (void)resolveJumpRequestForPlayer:(NJPlayer *)player sinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    NJCharacter *ninja = player.ninja;
    if (player.fromPile.standingCharacter == ninja) {
        player.fromPile.standingCharacter = nil;
    }
    if (hypotf(ninja.position.x-player.targetPile.position.x, ninja.position.y-player.targetPile.position.y)>CGRectGetWidth(player.targetPile.frame)/2) {
        // If it is not close enough, calculate the amount of distance the ninja should have jumped and let the ninja to jump to that position
        [ninja jumpToPile:player.targetPile fromPile:player.fromPile withTimeInterval:timeSinceLast];
    } else {
        // If the ninja is close enough to its target pile, it snaps to the target pile
        player.jumpRequested = NO;
        player.isJumping = NO;
        player.finishJumpping = YES;
        player.jumpCooldown = 0;
        [player runJumpTimerAction];
        
        if (player.targetPile.standingCharacter) {
            // If there is any character standing in the target pile, attack the character.
            NJPlayer *p = player.targetPile.standingCharacter.player;
            if (!p.isDisabled) {
                [ninja attackCharacter:p.ninja];
                NJPile *pile = [self spawnAtRandomPileForNinja:YES];
                pile.standingCharacter = p.ninja;
                if (pile.itemHolded) {
                    [(NSMutableArray*)self.items removeObject:pile.itemHolded];
                    [pile.itemHolded removeFromParent];
                    [pile.itemHolded.itemShadow removeFromParent];
                }
                
                if (pile.itemEffectOnPile){
                    NJItemEffect *effect = pile.itemEffectOnPile;
                    if (effect.owner != p.ninja) {
                        [effect removeAllActions];
                        [effect removeFromParent];
                        pile.itemEffectOnPile = nil;
                    }
                }
                if (pile.isOnFire){
                    pile.isOnFire = NO;
                }
                
                [p.ninja resetToPosition:pile.position];
                p.targetPile = nil;
                p.jumpRequested = NO;
                p.isJumping = NO;
            }
        }
        
        // If there is any item effect imposed on the target file, for example if the pile is on fire, perform the corresponding effect to the jumping character
        if (player.targetPile.isOnFire) {
            [player.ninja applyDamage:10];
        }
        
        player.targetPile.standingCharacter = ninja;
        ninja.position = player.targetPile.position;
        
        //pick up items if needed
        [player.ninja pickupItem:self.items onPile:player.targetPile];
        player.itemIndicatorAdded = NO;
    }
}

- (CGPoint)determinePositionOfHpBarIndexedBy:(NSUInteger)index
{
    CGPoint position;
    float size = 250;
    float offset = 10;
    
    switch (index) {
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
    return position;
}


#pragma mark - NJButtonDelegate
- (void)button:(NJButton *)button touchesBegan:(NSSet *)touches {
    button.colorBlendFactor = 0.0;
}

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches {
    button.colorBlendFactor = kButtonColorBlendFactor;
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
        }
    }
}

#pragma mark - NJItemControlDelegate
- (void)itemControl:(NJItemControl *)control touchesBegan:(NSSet *)touches
{
    control.colorBlendFactor = 0.0;
}

- (void)itemControl:(NJItemControl *)control touchesEnded:(NSSet *)touches
{
    control.colorBlendFactor = kButtonColorBlendFactor;
    NSArray *ninjas = self.ninjas;
    if ([ninjas count]<1) {
        return ;
    }
    // Use Item
    if (control.player.ninja.frozenCount == 0) {
        control.player.itemUseRequested = YES;
    }
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

- (void)addCharacter:(NJCharacter *)character
{
    [self addNode:character atWorldLayer:NJWorldLayerCharacter];
}

- (void)addEffectNode:(SKSpriteNode *)effectNode
{
    [self addNode:effectNode atWorldLayer:NJWorldLayerAboveCharacter];
}
@end

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

#import "NJItemEffect.h"

#define BUTTON_COLORBLEND_FACTOR 0.5

@interface NJMultiplayerLayeredCharacterScene ()  <SKPhysicsContactDelegate, NJButtonDelegate,NJItemControlDelegate, NJBGclickingDelegate, NJScrollDelegate,NJCharacterDelegate>

@end

@implementation NJMultiplayerLayeredCharacterScene

{
    NJGameMode _gameMode;
    NSUInteger _bossIndex;
    BOOL isSelectionInited;
    BOOL isFirstTimeInitialized;
    BOOL isGameEnded;
    BOOL shouldPileStartDecreasing;
    AVAudioPlayer *music;
    NSUInteger kNumberOfFramesToSpawnItem;
    BOOL hasBeenPaused;
}

#pragma mark - Initialization
- (instancetype)initWithSize:(CGSize)size mode:(NJGameMode)mode
{
    self = [self initWithSize:size];
    if (self) {
        _gameMode = mode;
        _world = [[SKNode alloc] init];
        [_world setName:@"world"];
        [self initLayers];
        [self initPlayers];
        [self addChild:_world];
        [self configurePhysicsBody];
        [self initItemFrequency];
        isSelectionInited = NO;
        isFirstTimeInitialized = YES;
        isGameEnded = NO;
        shouldPileStartDecreasing = NO;
        self.doAddItemRandomly = YES;
        hasBeenPaused = false;
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

- (void)addNode:(SKNode *)node atWorldLayer:(NJWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.friction = 0.0;
    self.physicsBody.linearDamping = 0.0;
    self.physicsBody.restitution = 1.0;
}

- (void)initLayers
{
    _layers = [NSMutableArray arrayWithCapacity:kWorldLayerCount];
    for (int i = 0; i < kWorldLayerCount; i++) {
        SKNode *layer = [[SKNode alloc] init];
        layer.zPosition = i - kWorldLayerCount;
        [_world addChild:layer];
        [(NSMutableArray *)_layers addObject:layer];
    }
}


- (void)initPlayers
{
    _players = [[NSMutableArray alloc] initWithCapacity:kNumPlayers];
    for (int i=0; i<kNumPlayers ; i++) {
        NJPlayer *player = [[NJPlayer alloc] init];
        [(NSMutableArray *)_players addObject:player];
    }
}

// Initialize the frequency of occurrence for special items according to the mode selected
- (void)initItemFrequency
{
    switch (_gameMode) {
        case NJGameModeOneVsThree:
            kNumberOfFramesToSpawnItem = 200;
            break;
        case NJGameModeBeginner:
            kNumberOfFramesToSpawnItem = 600;
            break;
        case NJGameModeSurvival:
            kNumberOfFramesToSpawnItem = 200;
            break;
        default:
            kNumberOfFramesToSpawnItem = 0;
            break;
    }
}

// Initialize the HP Bars for each player. This is a node where the amount of health points of a ninja is reflected on the screen
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
    
    ((NJItemControl *)_itemControls[0]).position = CGPointMake(0+xDiff, 0+yDiff);
    ((NJItemControl *)_itemControls[0]).zRotation = - M_PI / 4;
    ((NJItemControl *)_itemControls[0]).color = kNinjaOneColor;
    ((NJItemControl *)_itemControls[0]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJItemControl *)_itemControls[1]).position = CGPointMake(1024-yDiff, xDiff);
    ((NJItemControl *)_itemControls[1]).zRotation = M_PI / 4;
    ((NJItemControl *)_itemControls[1]).color = kNinjaTwoColor;
    ((NJItemControl *)_itemControls[1]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJItemControl *)_itemControls[2]).position = CGPointMake(1024-xDiff, 768-yDiff);
    ((NJItemControl *)_itemControls[2]).zRotation = 3* M_PI / 4;
    ((NJItemControl *)_itemControls[2]).color = kNinjaThreeColor;
    ((NJItemControl *)_itemControls[2]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJItemControl *)_itemControls[3]).position = CGPointMake(yDiff, 768-xDiff);
    ((NJItemControl *)_itemControls[3]).zRotation = -3*M_PI / 4;
    ((NJItemControl *)_itemControls[3]).color = kNinjaFourColor;
    ((NJItemControl *)_itemControls[3]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    
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
    
    ((NJButton*)_buttons[0]).position = CGPointMake(yDiff, xDiff);
    ((NJButton*)_buttons[0]).zRotation = -M_PI/4;
    ((NJButton*)_buttons[0]).color = kNinjaOneColor;
    ((NJButton*)_buttons[0]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJButton*)_buttons[0]).player.color = kNinjaOneColor;
    ((NJButton*)_buttons[1]).position = CGPointMake(1024-xDiff, yDiff);
    ((NJButton*)_buttons[1]).zRotation = M_PI/4;
    ((NJButton*)_buttons[1]).color = kNinjaTwoColor;
    ((NJButton*)_buttons[1]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJButton*)_buttons[1]).player.color = kNinjaTwoColor;
    ((NJButton*)_buttons[2]).position = CGPointMake(1024-yDiff, 768-xDiff);
    ((NJButton*)_buttons[2]).zRotation = M_PI/4*3;
    ((NJButton*)_buttons[2]).color = kNinjaThreeColor;
    ((NJButton*)_buttons[2]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJButton*)_buttons[2]).player.color = kNinjaThreeColor;
    ((NJButton*)_buttons[3]).position = CGPointMake(xDiff, 768-yDiff);
    ((NJButton*)_buttons[3]).zRotation = -M_PI/4*3;
    ((NJButton*)_buttons[3]).color = kNinjaFourColor;
    ((NJButton*)_buttons[3]).colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
    ((NJButton*)_buttons[3]).player.color = kNinjaFourColor;
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
            player.shouldBlendCharacter = YES;
            if (index == _bossIndex) {
                player.shouldBlendCharacter = NO;
            }
            NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
            [self addNode:ninja.shadow atWorldLayer:NJWorldLayerBelowCharacter];
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
        ninja.colorBlendFactor = 0.6;
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

- (void)addItem{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
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
    NJSpecialItem *item = [self generateRandomItem];
    if (item != nil) {
        pile.itemHolded = item;
        item.position = position;
        item.itemShadow.position = position;
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [self addNode:item.itemShadow atWorldLayer:NJWorldLayerBelowCharacter];
        [_items addObject:item];
    }
}

- (NJSpecialItem *)generateRandomItem
{
    int index = arc4random() % NJItemCount;
    NJSpecialItem *item;
    
    CGPoint position = CGPointZero;
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
    if (item) {
        item.myParent = self;
    }
    return item;
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
    if (!_woodPiles) {
        _woodPiles = [NSMutableArray array];
    }
    
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
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:kBackgroundFileName];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
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
        [self checkGameEnded];
        [self applyImpulseToSlowWoodpiles];
        [self removePickedUpItem];
        [self removeOutdatedItem];
    }
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    [self updateNinjaStatesSinceLastUpdate:timeSinceLast];
    [self decreasePilesSinceLastUpdate:timeSinceLast];
    [self updateWoodpilesSinceLastUpdate:timeSinceLast];
    [self updateItemControlsSinceLastUpdate:timeSinceLast];
    [self updateItemsSinceLastUpdate:timeSinceLast];
    [self resolveJumpRequestSinceLastUpdate:timeSinceLast];
}

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
    
    if (_gameMode == NJGameModeOneVsThree) {
        if (!isGameEnded && ((NJPlayer *)self.players[_bossIndex]).ninja.isDying){
            isGameEnded = YES;
//            for (int i=0; i<4; i++) {
//                if (((NJPlayer *)self.players[i]).isDisabled == NO) {
                    [self victoryAnimationToPlayer:0];
//                }
//            }
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
    button.colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
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

- (void)itemControl:(NJItemControl *)control touchesBegan:(NSSet *)touches
{
    control.colorBlendFactor = 0.0;
}

- (void)itemControl:(NJItemControl *)control touchesEnded:(NSSet *)touches
{
    control.colorBlendFactor = BUTTON_COLORBLEND_FACTOR;
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
    [NJNinjaCharacterBoss loadSharedAssets];
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
    [music pause];
    
    [self showPausePanel];
}

- (void)restartOrContinue:(NSNotification *)note
{
    NSUInteger actionIndex = [(NSNumber *)[note object] integerValue];
    if (!isSelectionInited && actionIndex == RESTART){
        [self restartGame];
    } else if(actionIndex == CONTINUE){
        hasBeenPaused = NO;
        self.physicsWorld.speed = 1;
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
    int musicIndex = arc4random() % [self.musicName count];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.musicName[musicIndex] ofType:@"mp3"]];
    
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
    NJSelectionButtonSystem *selectionSystem = nil;
    if (_gameMode == NJGameModeOneVsThree) {
        selectionSystem = [[NJ1V3SelectionButtonSystem alloc] init];
    } else {
        selectionSystem = [[NJSelectionButtonSystem alloc]init];
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
        //NSLog(@"activated %d",[index intValue]);
        //int convertedIndex = [self convertIndex:[index intValue]];
        ((NJPlayer *)self.players[[index intValue]]).isDisabled = YES;
//        [((NJPlayer *)self.players[[index intValue]]).ninja.shadow removeFromParent];
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

- (void) activateSelectedPlayersWithPreSetting{
    [self initHpBars];
    [self initButtonsAndItemControls];
    [self initCharacters];
    if (_gameMode != NJGameModeBeginner && _gameMode != NJGameModeTutorial) {
        shouldPileStartDecreasing = YES;
    }
}

#pragma mark - Auxiliary Methods
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

- (void)updateWoodpilesSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
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
}

- (void)updateItemControlsSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJItemControl *control in _itemControls) {
        [control updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

- (void)updateItemsSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    for (NJSpecialItem *item in self.items){
        [item updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

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

- (void)updateHpBars
{
    for (NJHPBar *bar in _hpBars) {
        [bar updateHealthPoint];
    }
}

- (void)spawnNewItems
{
    int toSpawnItem = arc4random() % kNumberOfFramesToSpawnItem;
    if (toSpawnItem==1 && self.doAddItemRandomly) {
        [self addItem];
    }
}

- (void)checkGameEnded
{
    if (!isGameEnded) {
        isGameEnded = [self isGameEnded];
    }
}

- (void)applyImpulseToSlowWoodpiles
{
    if (_gameMode != NJGameModeBeginner && _gameMode != NJGameModeTutorial) {
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

- (void)resolveJumpRequestSinceLastUpdate:(NSTimeInterval)timeSinceLast
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
                    player.finishJumpping = YES;
                    player.jumpCooldown = 0;
                    [player runJumpTimerAction];
                    
                    if (player.targetPile.standingCharacter) {
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
                    
                    if (player.targetPile.isOnFire) {
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
            } else {
                player.jumpCooldown += timeSinceLast;
            }
        }
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

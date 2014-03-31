//
//  NJLevelSceneWaterPark.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLevelSceneWaterPark.h"
#import "NJNinjaCharacter.h"
#import "NJPile.h"
#import "NJPath.h"
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

#define kBackGroundFileName @"waterParkBG.png"
#define kThunderScrollFileName @"thunderScroll.png"
#define kWindScrollFileName @"windScroll.png"
#define kIceScrollFileName @"iceScroll.png"
#define kFireScrollFileName @"fireScroll.png"
#define kMineFileName @"mine.png"
#define kShurikenFileName @"shuriken.png"
#define kMedikitFileName @"medikit.png"

#define kNumOfFramesToSpawnItem 10

@interface NJLevelSceneWaterPark ()  <SKPhysicsContactDelegate, NJButtonDelegate,NJItemControlDelegate, NJBGclickingDelegate>
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic, readwrite) NSMutableArray *woodPiles;// all the wood piles in the scene
@property (nonatomic ,readwrite) NSMutableArray *items;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray *itemControls;
@property (nonatomic) NSMutableArray *hpBars;
@end

@implementation NJLevelSceneWaterPark{
    bool isSelectionInited;
    BOOL isFirstTimeInitialized;
}

@synthesize ninjas = _ninjas;
@synthesize woodPiles = _woodPiles;
@synthesize items = _items;
@synthesize buttons = _buttons;
@synthesize itemControls = _itemControls;

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.usesPreciseCollisionDetection = YES;
        _ninjas = [[NSMutableArray alloc] init];
        _items = [[NSMutableArray alloc] init];
        _woodPiles = [[NSMutableArray alloc] init];
        isSelectionInited = NO;
        isFirstTimeInitialized = YES;
        [self buildWorld];
        [self initCharacters];
        [self initSelectionSystem];
    }
    return self;
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
    
    double xDiff = 40, yDiff=90;
    
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
    ((NJItemControl *)_itemControls[0]).zRotation = -M_PI / 4;
    ((NJItemControl *)_itemControls[1]).position = CGPointMake(1024-xDiff, yDiff);
    ((NJItemControl *)_itemControls[1]).zRotation = M_PI / 4;
    ((NJItemControl *)_itemControls[2]).position = CGPointMake(1024-yDiff, 768-xDiff);
    ((NJItemControl *)_itemControls[2]).zRotation = -3*M_PI / 4;
    ((NJItemControl *)_itemControls[3]).position = CGPointMake(xDiff, 768-yDiff);
    ((NJItemControl *)_itemControls[3]).zRotation = 3*M_PI / 4;
}

- (void)initCharacters
{
    if (!_ninjas) {
        _ninjas = [NSMutableArray array];
    }
    
    for (int index=0; index<4; index++) {
        NJPlayer *player = self.players[index];
        if (!player.isDisabled) {
            NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
            CGPoint spawnPosition = ((NJPile*)_woodPiles[index]).position;
            ninja.position = spawnPosition;
            [ninja setSpawnPoint:spawnPosition];
        }else if(player.ninja){
            [player.ninja removeFromParent];
        }
    }
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
    CGPoint position = [self spawnAtRandomPosition];
    
    if ([self.items count] < 3) {
        int index = arc4random() % NJItemCount;
        NJSpecialItem *item;
        
        switch (index) {
//            case NJItemThunderScroll:
//                item = [[NJThunderScroll alloc] initWithTextureNamed:kThunderScrollFileName atPosition:position];
//                break;
//                
//            case NJItemWindScroll:
//                item = [[NJWindScroll alloc] initWithTextureNamed:kWindScrollFileName atPosition:position];
//                break;
                
            case NJItemIceScroll:
                item = [[NJIceScroll alloc] initWithTextureNamed:kIceScrollFileName atPosition:position];
                break;
                
            case NJItemFireScroll:
                item = [[NJFireScroll alloc] initWithTextureNamed:kFireScrollFileName atPosition:position];
                break;
//
//            case NJItemMedikit:
//                item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
//                break;
//            
//            case NJItemMine:
//                item = [[NJMine alloc] initWithTextureNamed:kMineFileName atPosition:position];
//                break;
//                
//            case NJItemShuriken:
//                item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
//                break;
                
            default:
                break;
        }
        
        if (item != nil) {
            item.myParent = self;
            [self addNode:item atWorldLayer:NJWorldLayerCharacter];
            [_items addObject:item];
        }
    }
}

- (BOOL)hasItemOnPosition:(CGPoint)position{
    for (NJSpecialItem *item in self.items){
        if (CGPointEqualToPointApprox(position, item.position)) {
//        if (CGPointEqualToPoint(position, item.position)) {
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
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:pos withSpeed:0 angularSpeed:3 direction:arc4random()%2 path:nil];
        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
    }
}

- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:kBackGroundFileName];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
}

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    // Update all players' ninjas.
    for (NJNinjaCharacter *ninja in self.ninjas) {
        [ninja updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    
    for (NJPile *pile in _woodPiles) {
        [pile updateWithTimeSinceLastUpdate:timeSinceLast];
        BOOL added = NO;
        for (NJNinjaCharacter *ninja in _ninjas) {
            if (CGPointEqualToPointApprox(ninja.position, pile.position)) {
                [pile addCharacterToPile:ninja];
                added = YES;
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
        
        if (!added && pile.standingCharacter) {
            [pile removeStandingCharacter];
        }
    }

    
    for (NJPile *pile in _woodPiles) {
        if (pile.isIceScrollEnabled) {
//            [pile.standingCharacter applyDamage:20];
            [pile.standingCharacter performFrozenEffect];
            pile.isIceScrollEnabled = NO;
        }
        
        if (pile.isThunderScrollEnabled) {
            [pile.standingCharacter applyDamage:20];
            pile.isThunderScrollEnabled = NO;
        }
        
        if (pile.isWindScrollEnabled) {
            [pile.standingCharacter applyDamage:20];
            pile.isWindScrollEnabled = NO;
        }
        
        if (pile.isFireScrollEnabled) {
            [pile.standingCharacter applyDamage:20];
            pile.isFireScrollEnabled = NO;
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
                [player.ninja useItem:player.item withWoodPiles:_woodPiles];
            }
            player.itemUseRequested = NO;
        }
    }
    
    for (NJHPBar *bar in _hpBars) {
        [bar updateHealthPoint];
    }
    
    int toSpawnItem = arc4random() % kNumOfFramesToSpawnItem;
    if (toSpawnItem==1) {
        [self addItem];
    }
}

#pragma mark - Event Handling

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches {    
    NSArray *ninjas = self.ninjas;
    if ([ninjas count] < 1) {
        return;
    }
    
    NJPile *pile = [self woodPileToJump:button.player.ninja];
    if (pile && !button.player.isJumping && button.player.ninja.frozenCount == 0) {
        button.player.startLocation = button.player.ninja.position;
        button.player.targetLocation = pile.position;
        button.player.jumpRequested = YES;
        button.player.isJumping = YES;
    } 
}

- (void)itemControl:(NJItemControl *)control touchesEnded:(NSSet *)touches
{
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
//        if (!CGPointEqualToPoint(pile.position, ninja.position)) {
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

- (CGPoint)spawnAtRandomPosition
{
    NSMutableArray *array = [NSMutableArray new];
    for (NJPile *pile in _woodPiles) {
        BOOL isFree = YES;
        for (NJPlayer *player in self.players) {
            if (CGPointEqualToPointApprox(pile.position, player.ninja.position) || (CGPointEqualToPointApprox(pile.position, player.targetLocation))) {
//            if (CGPointEqualToPoint(pile.position, player.ninja.position) || (CGPointEqualToPoint(pile.position, player.targetLocation))) {
                isFree = NO;
            }
        }
        for (NJSpecialItem *item in self.items){
            if (CGPointEqualToPointApprox(pile.position, item.position)) {
                isFree = NO;
            }
        }
        if (isFree) {
            [array addObject:pile];
        }
    }
    int index = arc4random() % [array count];
    CGPoint spawnPosition = ((NJPile*)array[index]).position;
    return spawnPosition;
}

#pragma mark - Shared Assets
+ (void)loadSceneAssets
{
    [NJNinjaCharacterNormal loadSharedAssets];
}

#pragma mark - Pause Game
- (void)addClickableArea
{
    NJResponsibleBG *clickableArea = [[NJResponsibleBG alloc] init];
    clickableArea.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:clickableArea atWorldLayer:NJWorldLayerAboveCharacter];
    clickableArea.delegate = self;
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
}

- (void)restartOrContinue:(NSNotification *)note
{
    NSUInteger actionIndex = [(NSNumber *)[note object]integerValue];
    if (!isSelectionInited && actionIndex == RESTART){
        for (int i=0; i<[self.players count]; i++) {
            NJPlayer *player = [self.players objectAtIndex:i];
            player.isDisabled = NO;
            [player.ninja reset];
        }
        
        [self resetWoodPiles];
        [self initSelectionSystem];
    } else if(actionIndex == CONTINUE){
        [self continueItemUpdate];
        [self continueWoodpiles];
    }
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

- (void)resetWoodPiles
{
    for (NJPile *pile in self.woodPiles) {
        [pile setSpeed:3 direction:NJDiectionClockwise];
    }
}


#pragma mark - Selection System

- (void)initSelectionSystem{
    NSLog(@"initselection");
    isSelectionInited = YES;
    NJSelectionButtonSystem *selectionSystem = [[NJSelectionButtonSystem alloc]init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    selectionSystem.position = center;
    [self addChild:selectionSystem];
    
    //add notification to actived players Index
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
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
            [player.ninja removeFromParent];
        }
    }
    
    [self initHpBars];
    [self initButtonsAndItemControls];
    [self initCharacters];
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


#pragma mark - Physics Delegate
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

#pragma mark - Delegate Methods

@end

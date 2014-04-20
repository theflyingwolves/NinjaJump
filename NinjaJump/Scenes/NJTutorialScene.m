//
//  NJTutorialScene.m
//  NinjaJump
//
//  Created by wulifu on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTutorialScene.h"
#import "NJPlayer.h"
#import "NJPile.h"
#import "NJGraphicsUnitilities.h"
#import "NJShuriken.h"
#import "NJMedikit.h"
#import "NJIceScroll.h"
#import "NJConstants.h"
#import "NJScroll.h"
#import "NJNinjaCharacter.h"
#import "NJHPBar.h"
#import "NJConstants.h"

#define kItemNameShuriken 0
#define kItemNameMedikit 1
#define kItemNameIceScroll 2

#define kNPCPositionX -330
#define kNPCPositionY -200
#define kDialogPositionX -150
#define kDialogPositionY -200
#define kNextButtonPositionX 87
#define kNextButtonPositionY -20
#define kHomeButtonPositionX 60
#define kHomeButtonPositionY 30


#define kImageDialogIntroFileName @"dialogIntro.png"
#define kImageDialogAttackFileName @"dialogAttack.png"
#define kImageDialogPickupShurikenFileName @"dialogPickupShuriken.png"
#define kImageDialogUseShurikenFileName @"dialogUseShuriken.png"
#define kImageDialogPickupMedikitFileName @"dialogPickupMedikit.png"
#define kImageDialogUseScrollFileName @"dialogUseScroll.png"
#define kImageDialogIntroScrollIndicatorFileName @"dialogIntroScrollIndicator.png"
#define kImageDialogFinishFileName @"dialogFinish.png"

typedef enum : uint8_t {
    NJTutorialPhaseIntro = 0,
	NJTutorialPhaseJump,
    NJTutorialPhaseIntroToAttack,
	NJTutorialPhaseAttack,
    NJTutorialPhaseIntroToPickupShuriken,
	NJTutorialPhasePickupShuriken,
    NJTutorialPhaseIntroToUseShuriken,
	NJTutorialPhaseUseShuriken,
    NJTutorialPhaseIntroToMedikit,
    NJTutorialPhasePickupMedikit,
    NJTutorialPhaseIntroToIce,
    NJTutorialPhasePickupIce,
    NJTutorialPhaseIndicator,
    NJTutorialPhaseUseIce,
    NJTutorialPhaseFinish
} NJTutorialPhase;

@interface NJTutorialScene ()  <NJScrollDelegate>

@end

@implementation NJTutorialScene{
    SKSpriteNode *cover;
    SKSpriteNode *NPC;
    SKSpriteNode *dialog;
    
    NSInteger dialogImageIndex;
    NSArray *dialogImageNames;
    
    
    BOOL isPaused;
    NSInteger phaseNum;
    CGFloat timeToGoToNextPhase;
}

#pragma mark - init

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSize:size mode:NJGameModeTutorial];
    if (self){
        dialogImageNames = [NSArray arrayWithObjects:kImageDialogIntroFileName, kImageDialogAttackFileName, kImageDialogPickupShurikenFileName, kImageDialogUseShurikenFileName, kImageDialogPickupMedikitFileName, kImageDialogUseScrollFileName, kImageDialogIntroScrollIndicatorFileName, kImageDialogFinishFileName, nil];
        dialogImageIndex = 0;
        
        [self initGameSettings];
        [self initCover];
        
        phaseNum = NJTutorialPhaseIntro;
        timeToGoToNextPhase = -1;
        
        [self disableControl];
        
        self.musicName = [NSArray arrayWithObjects:kMusicFunny, nil];
        [self resetMusic];
    }
    
    return  self;
}


- (void)initGameSettings {
    ((NJPlayer*)self.players[1]).isDisabled = NO;
    ((NJPlayer*)self.players[3]).isDisabled = YES;
    ((NJPlayer*)self.players[2]).isDisabled = YES;
    ((NJPlayer*)self.players[0]).isDisabled = YES;
    
    ((NJPlayer*)self.players[1]).finishJumpping = NO;
    
    [self activateSelectedPlayersWithPreSetting];
    self.doAddItemRandomly = NO;
}

- (void)initCover{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    cover = [[SKSpriteNode alloc] init];
    cover.size = CGSizeMake(screenHeight, screenWidth);
    cover.position = center;
    cover.alpha = 1;
    cover.userInteractionEnabled = YES;
    cover.color = [UIColor clearColor];

    NPC = [[SKSpriteNode alloc] initWithImageNamed:@"NPC2.png"];
    NPC.position = CGPointMake(kNPCPositionX, kNPCPositionY);
    NPC.size = CGSizeMake(700/2.0, 768/2.0);
    [cover addChild:NPC];
    
    dialog = [[SKSpriteNode alloc] initWithImageNamed:dialogImageNames[dialogImageIndex]];
    dialog.position = CGPointMake(kDialogPositionX, kDialogPositionY);
    dialog.size = CGSizeMake(600/2.0, 410/2.0);
    [cover addChild:dialog];
    
    self.nextButton = [[NJTuTorialNextButton alloc] init];
    [dialog addChild:self.nextButton];
    self.nextButton.delegate = self;
    self.nextButton.position = CGPointMake(kNextButtonPositionX, kNextButtonPositionY);
    
    self.homeButton = [[NJTutorialHomeButton alloc] init];
    self.homeButton.delegate = self;
    self.homeButton.position = CGPointMake(kHomeButtonPositionX, kHomeButtonPositionY);
}


#pragma mark - control

- (void)disableControl{
    [self addChild:cover];
    isPaused = YES;
}

- (void)enableControl{
    [cover removeFromParent];
    isPaused = NO;
}

- (void)nextImageForDialog{
    dialogImageIndex++;
    dialog.texture = [SKTexture textureWithImageNamed:dialogImageNames[dialogImageIndex]];
}

- (void)toggleControl{
    if (isPaused) {
        [self enableControl];
        [self addChild:self.homeButton];
    } else {
        [self nextImageForDialog];
        [self disableControl];
        [self.homeButton removeFromParent];
    }
}

- (void)goToNextPhaseWithDelay {
    if (timeToGoToNextPhase == -1) {
        phaseNum++;
        [self hideGuide];
        [self toggleControl];
        timeToGoToNextPhase = 1;
    }
}

- (void)goToNextPhase {
    phaseNum++;
    [self toggleControl];
}

- (void)showGuide{
    [cover addChild:NPC];
    [cover addChild:dialog];
}

- (void)hideGuide{
    [NPC removeFromParent];
    [dialog removeFromParent];
}

- (void)activateDummyPlayer{
    NJPlayer *player = self.players[3];
    player.isDisabled = NO;
    NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
    [self addNode:ninja.shadow atWorldLayer:NJWorldLayerBelowCharacter];
    NJPile *pile = [self spawnAtRandomPileForNinja:NO];
    pile.standingCharacter = ninja;
    ninja.position = pile.position;
    
    if (!((NJHPBar *)self.hpBars[3]).parent) {
        [self addChild:self.hpBars[3]];
    }
}

#pragma mark - game setting utility

- (void)addItem:(NSInteger)itemName{
    if (!self.items) {
        self.items = [NSMutableArray array];
    }
    
    NJPile *pile = [self spawnAtRandomPileForNinja:NO];
    if (!pile) {
        return;
    }
    CGPoint position = pile.position;
    
    NJSpecialItem *item;
    
    switch (itemName) {
        case kItemNameIceScroll:
        item = [[NJIceScroll alloc] initWithTextureNamed:kIceScrollFileName atPosition:position delegate:self];
        break;
        
        case kItemNameMedikit:
        item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
        break;
        
        case kItemNameShuriken:
        item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
        break;
        
        default:
        break;
    }
    
    if (item != nil) {
        item.myParent = self;
        pile.itemHolded = item;
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [self.items addObject:item];
    }

}

- (SKSpriteNode*)createArrowWithVector:(CGVector)vector andPosition:(CGPoint)position andDirectionIsNormal:(BOOL)directionIsNormal{
    
    SKSpriteNode *arrow;
    if (directionIsNormal) {
        arrow = [[SKSpriteNode alloc] initWithImageNamed:@"arrow.png"];
    } else {
        arrow = [[SKSpriteNode alloc] initWithImageNamed:@"arrowReverse.png"];
    }
    
    arrow.size = CGSizeMake(600/6.0, 400/7.0);
    arrow.position = position;
    
    SKAction *moveForward = [SKAction moveBy:vector duration:0.25];
    SKAction *moveBackward = [SKAction moveBy:CGVectorMake(-vector.dx,-vector.dy) duration:0.5];
    SKAction *moveBackAndForth = [SKAction sequence:[NSArray arrayWithObjects:moveBackward, moveForward, nil]];
    SKAction *repeat = [SKAction repeatAction:moveBackAndForth count:3];
    [arrow runAction:repeat completion:^(void){
        [arrow removeFromParent];
    }];
    return arrow;
}




#pragma mark - overriden method

- (void)addWoodPiles
{
    if (!self.woodPiles) {
        self.woodPiles = [NSMutableArray array];
    }
    
    CGFloat r= 120.0f;
    
    NSArray *pilePos = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:CGPointMake(r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(512, 580)], [NSValue valueWithCGPoint:CGPointMake(250, 250)], [NSValue valueWithCGPoint:CGPointMake(350, 100)], [NSValue valueWithCGPoint:CGPointMake(650, 350)], [NSValue valueWithCGPoint:CGPointMake(850, 400)], [NSValue valueWithCGPoint:CGPointMake(100, 300)], [NSValue valueWithCGPoint:CGPointMake(250, 500)], [NSValue valueWithCGPoint:CGPointMake(550, 400)], [NSValue valueWithCGPoint:CGPointMake(700, 600)], [NSValue valueWithCGPoint:CGPointMake(750, 150)], nil];
    
    //add in the spawn pile of ninjas
    for (NSValue *posValue in pilePos){
        CGPoint pos = [posValue CGPointValue];
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:pos withSpeed:0 angularSpeed:3 direction:arc4random()%2];
        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
    }
}

- (void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];

    switch (phaseNum) {
        case NJTutorialPhaseJump:
            if (((NJPlayer*)self.players[1]).finishJumpping == YES) {
                [self goToNextPhaseWithDelay];
            }
            break;
            
        case NJTutorialPhaseAttack:
            if (((NJPlayer*)self.players[3]).ninja.health <FULL_HP){
                [self goToNextPhaseWithDelay];
            }
            break;
        
        case NJTutorialPhasePickupShuriken:
            if (((NJPlayer*)self.players[1]).item) {
                [self goToNextPhaseWithDelay];
            } else {
                if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item){
                    [self addItem:kItemNameShuriken];
                }
            }
            break;
            
        case NJTutorialPhaseUseShuriken:
            if (!((NJPlayer*)self.players[1]).item) {
                [self goToNextPhaseWithDelay];
            }
            break;
            
        case NJTutorialPhasePickupMedikit:
            if (((NJPlayer*)self.players[1]).ninja.health == FULL_HP) {
                [self goToNextPhaseWithDelay];
            } else {
                if ([self.items count] == 0){
                    [self addItem:kItemNameMedikit];
                }
            }
            break;
        
        case NJTutorialPhasePickupIce:
            if (((NJPlayer*)self.players[1]).item) {
                [self goToNextPhaseWithDelay];
            } else {
                if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item){
                    [self addItem:kItemNameIceScroll];
                }
            }
            break;
        
        case NJTutorialPhaseUseIce:
            if (!((NJPlayer*)self.players[1]).item) {
                if (((NJPlayer*)self.players[3]).ninja.frozenCount > 0){
                    [self goToNextPhaseWithDelay];
                } else if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item) {
                    [self addItem:kItemNameIceScroll];
                }
            }

            break;
        
        

        default:
            break;
    }
    
    if (((NJPlayer*)self.players[3]).ninja.health <(FULL_HP-20)) {
        if (phaseNum < NJTutorialPhaseUseShuriken) {
            ((NJPlayer*)self.players[3]).ninja.health = FULL_HP-20;
        }
    }
    if (((NJPlayer*)self.players[3]).ninja.health <(FULL_HP-40)) {
        ((NJPlayer*)self.players[3]).ninja.health = FULL_HP-40;
    }
}

- (bool)isGameEnded{
    return NO;
}

- (void)backgroundTouchesEnded:(NSSet *)touches{
    
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast{
    [super updateWithTimeSinceLastUpdate:timeSinceLast];
    
    if (timeToGoToNextPhase < 0 && timeToGoToNextPhase > -1) {
        [self showGuide];
        timeToGoToNextPhase = -1;
    } else if(timeToGoToNextPhase > 0) {
        timeToGoToNextPhase -= timeSinceLast;
    }
    
    for (NJSpecialItem *item in self.items){
        item.lifeTime -= timeSinceLast;
    }
}

- (NSArray *)getAffectedTargetsWithRange:(NJRange *)range
{
    return [super getAffectedTargetsWithRange:range];
}

- (NSArray *)getAffectedPilesWithRange:(NJRange *)range
{
    return [super getAffectedPilesWithRange:range];
}


#pragma mark - delegate method
- (void)nextButton:(NJTuTorialNextButton *) button touchesEnded:(NSSet *)touches{
    if (button == self.nextButton) {
        switch (phaseNum) {
            case NJTutorialPhaseIntro:
                [self toggleControl];
                phaseNum++;
                [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(865, 100) andDirectionIsNormal:YES]];
            
                break;
                
            case NJTutorialPhaseIntroToAttack:
                [self toggleControl];
                phaseNum++;
                [self activateDummyPlayer];
            
                [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(((NJPlayer*)self.players[3]).ninja.position.x-110, ((NJPlayer*)self.players[3]).ninja.position.y) andDirectionIsNormal:YES]];
            
                break;
            
            case NJTutorialPhaseIntroToPickupShuriken:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameShuriken];
            
                [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(((NJSpecialItem*)self.items[0]).position.x-110, ((NJSpecialItem*)self.items[0]).position.y) andDirectionIsNormal:YES]];
            
                break;
                
            case NJTutorialPhaseIntroToUseShuriken:
                [self toggleControl];
                phaseNum++;
            
                [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(800, 50) andDirectionIsNormal:YES]];

                break;
 
            case NJTutorialPhaseIntroToMedikit:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameMedikit];
                ((NJPlayer*)self.players[1]).ninja.health -= 40;
            
                [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(((NJSpecialItem*)self.items[0]).position.x-110, ((NJSpecialItem*)self.items[0]).position.y) andDirectionIsNormal:YES]];
            
                break;
                
            case NJTutorialPhaseIntroToIce:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameIceScroll];
                break;
            
            case NJTutorialPhaseIndicator:
                [self toggleControl];
                phaseNum++;
            
                NSLog(@"%f, %f", ((NJPlayer*)self.players[1]).ninja.position.x, ((NJPlayer*)self.   players[1]).ninja.position.y);
                if (((NJPlayer*)self.players[1]).ninja.position.x >= 200) {
                    [self addChild:[self createArrowWithVector:CGVectorMake(-30, 0) andPosition:CGPointMake(((NJPlayer*)self.players[1]).ninja.position.x-250, ((NJPlayer*)self.players[1]).ninja.position.y) andDirectionIsNormal:YES]];
                } else {
                    [self addChild:[self createArrowWithVector:CGVectorMake(30, 0) andPosition:CGPointMake(((NJPlayer*)self.players[1]).ninja.position.x+250, ((NJPlayer*)self.players[1]).ninja.position.y) andDirectionIsNormal:NO]];
                    
                }
            
                break;
            
            case NJTutorialPhaseFinish:
                [self.delegate backToModeSelectionScene];
                break;
            
            
            
            
            
            default:
                break;
        }
    }
}

- (void)homeButton:(NJTutorialHomeButton *) button touchesEnded:(NSSet *)touches{
    [self.music pause];
    self.music = nil;
    [self.delegate backToModeSelectionScene];
}

@end

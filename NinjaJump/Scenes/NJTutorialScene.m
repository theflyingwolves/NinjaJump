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

//constants for positions of image on the screen
#define kNPCPositionX -330
#define kNPCPositionY -200
#define kDialogPositionX -150
#define kDialogPositionY -200
#define kNextButtonPositionX 87
#define kNextButtonPositionY -20
#define kHomeButtonPositionX 60
#define kHomeButtonPositionY 30

//file names for dialog image
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
    SKSpriteNode *cover; //a transparent cover to hold images and prevent touch event
    SKSpriteNode *NPC;
    SKSpriteNode *dialog;
    
    NSInteger dialogImageIndex;
    NSArray *dialogImageNames; //an array to store the image names for different dialogs
    
    BOOL isPaused; //just an indicator to show that whether the game control is disabled
    NSInteger phaseNum; //phase of the tutorial
    CGFloat timeToGoToNextPhase; //a small time break between completion of a task and the appearance of the NPC
}

#pragma mark - init

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSize:size mode:NJGameModeTutorial];
    if (self){
        [self initDialogImageNames];
        [self initGameSettings];
        [self initCover];
        [self initPhaseSetting];
        [self disableControl];
        [self initMusic];
    }
    
    return  self;
}

//add all the dialog image names into the array
- (void)initDialogImageNames {
    dialogImageNames = [NSArray arrayWithObjects:kImageDialogIntroFileName, kImageDialogAttackFileName, kImageDialogPickupShurikenFileName, kImageDialogUseShurikenFileName, kImageDialogPickupMedikitFileName, kImageDialogUseScrollFileName, kImageDialogIntroScrollIndicatorFileName, kImageDialogFinishFileName, nil];
    dialogImageIndex = 0;
}

- (void)initPhaseSetting {
    phaseNum = NJTutorialPhaseIntro;
    timeToGoToNextPhase = -1;
}

- (void)initMusic {
    self.musicName = [NSArray arrayWithObjects:kMusicFunny, nil];
    [self resetMusic];
}

- (void)initCover{
    [self initCoverBackground];
    [self initNPC];
    [self initDialog];
    [self initButtons];
}

//only create one player
- (void)initGameSettings {
    ((NJPlayer*)self.players[1]).isDisabled = NO;
    ((NJPlayer*)self.players[3]).isDisabled = YES;
    ((NJPlayer*)self.players[2]).isDisabled = YES;
    ((NJPlayer*)self.players[0]).isDisabled = YES;
    
    ((NJPlayer*)self.players[1]).finishJumpping = NO;
    
    [self activateSelectedPlayersWithPreSetting];
    self.doAddItemRandomly = NO; //diable automatic item creation
}

//init a tranparent background for cover
- (void)initCoverBackground {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    cover = [[SKSpriteNode alloc] init];
    cover.size = CGSizeMake(screenHeight, screenWidth);
    cover.position = center;
    cover.alpha = 1;
    cover.userInteractionEnabled = YES;
    cover.color = [UIColor clearColor];
}

- (void)initNPC {
    NPC = [[SKSpriteNode alloc] initWithImageNamed:@"NPC2.png"];
    NPC.position = CGPointMake(kNPCPositionX, kNPCPositionY);
    NPC.size = CGSizeMake(700/2.0, 768/2.0);
    [cover addChild:NPC];
}

- (void)initDialog {
    dialog = [[SKSpriteNode alloc] initWithImageNamed:dialogImageNames[dialogImageIndex]];
    dialog.position = CGPointMake(kDialogPositionX, kDialogPositionY);
    dialog.size = CGSizeMake(600/2.0, 410/2.0);
    [cover addChild:dialog];
}

- (void)initButtons {
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
    [self addChild:cover]; //add the cover to disable touch event and also show the NPC and    dialog
    isPaused = YES;
}

- (void)enableControl{
    [cover removeFromParent]; //remove the NPC and dialog and also enable control
    isPaused = NO;
}

//change dialog image
- (void)nextImageForDialog{
    dialogImageIndex++;
    dialog.texture = [SKTexture textureWithImageNamed:dialogImageNames[dialogImageIndex]];
}

//toggle between free control and NPC dialog
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

//when the cover is present, show the NPC and dialog
- (void)showGuide{
    [cover addChild:NPC];
    [cover addChild:dialog];
}

//when the cover is present, hide the NPC and dialog (but control is still disabled)
- (void)hideGuide{
    [NPC removeFromParent];
    [dialog removeFromParent];
}

//activate the enemy
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
    
    //can only add 3 types of item
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

//create an arrow to indicate the position of important object
- (SKSpriteNode*)createArrowWithVector:(CGVector)vector andPosition:(CGPoint)position andDirectionIsNormal:(BOOL)directionIsNormal{
    
    SKSpriteNode *arrow;
    if (directionIsNormal) {
        arrow = [[SKSpriteNode alloc] initWithImageNamed:@"arrow.png"];
    } else {
        arrow = [[SKSpriteNode alloc] initWithImageNamed:@"arrowReverse.png"];
    }
    
    arrow.size = CGSizeMake(600/6.0, 400/7.0);
    arrow.position = position;
    
    //animate the arrow
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

- (void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];

    //check whether the task of a specific phase is completed
    switch (phaseNum) {
        case NJTutorialPhaseJump:
            if (((NJPlayer*)self.players[1]).finishJumpping == YES) {  //when finish jumping
                [self goToNextPhaseWithDelay];
            }
            break;
            
        case NJTutorialPhaseAttack:
            if (((NJPlayer*)self.players[3]).ninja.health <FULL_HP){ //when finish attacking
                [self goToNextPhaseWithDelay];
            }
            break;
        
        case NJTutorialPhasePickupShuriken:
            if (((NJPlayer*)self.players[1]).item) { //when finsih picking up the shuriken
                [self goToNextPhaseWithDelay];
            } else {
                //if shuriken disappears for some reason but hasn't been picked up
                //recreate it
                if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item){
                    [self addItem:kItemNameShuriken];
                }
            }
            break;
            
        case NJTutorialPhaseUseShuriken:
            if (!((NJPlayer*)self.players[1]).item) { //when finish using shuriken
                [self goToNextPhaseWithDelay];
            }
            break;
            
        case NJTutorialPhasePickupMedikit:
            if (((NJPlayer*)self.players[1]).ninja.health == FULL_HP) { //when finish picking up medikit
                [self goToNextPhaseWithDelay];
            } else {
                if ([self.items count] == 0){
                    [self addItem:kItemNameMedikit];
                }
            }
            break;
        
        case NJTutorialPhasePickupIce:
            if (((NJPlayer*)self.players[1]).item) { //when finish picking up the ice scroll
                [self goToNextPhaseWithDelay];
            } else {
                //if scroll disappears for some reason but hasn't been picked up
                //recreate it
                if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item){
                    [self addItem:kItemNameIceScroll];
                }
            }
            break;
        
        case NJTutorialPhaseUseIce:
            if (!((NJPlayer*)self.players[1]).item) { //when the scroll is used
                if (((NJPlayer*)self.players[3]).ninja.frozenCount > 0){
                    [self goToNextPhaseWithDelay];
                } else if ([self.items count] == 0 && !((NJPlayer*)self.players[1]).item) {
                    //if the enemy is not frozen
                    //recreate the scorll
                    [self addItem:kItemNameIceScroll];
                }
            }

            break;

        default:
            break;
    }
    
    if (((NJPlayer*)self.players[3]).ninja.health <(FULL_HP-20)) {
        if (phaseNum < NJTutorialPhaseUseShuriken) {
            //ensure the lower bound of HP of the enemy
            ((NJPlayer*)self.players[3]).ninja.health = FULL_HP-20;
        }
    }
    if (((NJPlayer*)self.players[3]).ninja.health <(FULL_HP-40)) {
        //ensure the lower bound of HP of the enemy
        ((NJPlayer*)self.players[3]).ninja.health = FULL_HP-40;
    }
}

//prevent default behavior
- (bool)isGameEnded{
    return NO;
}

- (void)backgroundTouchesEnded:(NSSet *)touches{
    //do nothing becasue we want to prevent the default behavior
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast{
    [super updateWithTimeSinceLastUpdate:timeSinceLast];
    
    //implement time break between completion of a task and appearance of the NPC
    if (timeToGoToNextPhase < 0 && timeToGoToNextPhase > -1) {
        [self showGuide];
        timeToGoToNextPhase = -1;
    } else if(timeToGoToNextPhase > 0) {
        timeToGoToNextPhase -= timeSinceLast;
    }
    
    //prevent the item from disappearing
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

//event handler for the next button in the dialog
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
            
                //since the rnage of the indicator is large, we need to decide whether to add
                //the arrow from left or from the right hand side
                if (((NJPlayer*)self.players[1]).ninja.position.x >= 200) { //add from left
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

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

#define kItemNameShuriken 0
#define kItemNameMedikit 1
#define kItemNameIceScroll 2

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
    NJTutorialPhaseUseIce
} NJTutorialPhase;

@interface NJTutorialScene ()  <NJScrollDelegate>{
    BOOL isPaused;
    SKSpriteNode *cover;
    NSInteger phaseNum;
}

@end


@implementation NJTutorialScene

#pragma init

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSizeWithoutSelection:size];
    if (self){
        [self initGameSettings];
        [self initButton];
        [self initCover];
        phaseNum = NJTutorialPhaseIntro;
        [self disableControl];
    }
    
    return  self;
}

- (void)initButton {
    self.nextButton = [[NJTuTorialNextButton alloc] init];
    [self addChild:self.nextButton];
    self.nextButton.delegate = self;
}

- (void)initGameSettings {
    ((NJPlayer*)self.players[0]).isDisabled = NO;
    ((NJPlayer*)self.players[1]).isDisabled = NO;
    ((NJPlayer*)self.players[2]).isDisabled = YES;
    ((NJPlayer*)self.players[3]).isDisabled = YES;
    
    ((NJPlayer*)self.players[0]).finishJumpping = NO;
    
    [self activateSelectedPlayersWithPreSetting];
    
    [self.itemControls[1] removeFromParent];
    [self.buttons[1] removeFromParent];
    self.doAddItemRandomly = NO;
}

- (void)initCover{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    cover = [[SKSpriteNode alloc] init];
    cover.size = CGSizeMake(screenHeight, screenWidth);
    cover.position = center;
    cover.alpha = 0;
    cover.userInteractionEnabled = YES;
    cover.color = [UIColor blackColor];
}


#pragma control

- (void)disableControl{
    [self addChild:cover];
    isPaused = YES;
}

- (void)enableControl{
    [cover removeFromParent];
    isPaused = NO;
}

- (void)toggleControl{
    if (isPaused) {
        [self enableControl];
    } else {
        [self disableControl];
    }
}


#pragma game setting utility

- (void)addItem:(NSInteger)itemName{
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




#pragma overriden method

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
    }
}

- (void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
//    if (!isPaused) {
//        [super update:currentTime];
//    }

    
    switch (phaseNum) {
        case NJTutorialPhaseJump:
            if (((NJPlayer*)self.players[0]).finishJumpping == YES) {
                [self toggleControl];
                phaseNum++;
            }
            break;
            
        case NJTutorialPhaseAttack:
            if (((NJPlayer*)self.players[1]).ninja.health <FULL_HP){
                [self toggleControl];
                phaseNum++;
            }
            break;
        
        case NJTutorialPhasePickupShuriken:
            if (((NJPlayer*)self.players[0]).item) {
                [self toggleControl];
                phaseNum++;
            }
            break;
            
        case NJTutorialPhaseUseShuriken:
            if (!((NJPlayer*)self.players[0]).item) {
                [self toggleControl];
                phaseNum++;
//                if (((NJPlayer*)self.players[1]).ninja.health <FULL_HP){
//                    [self toggleControl];
//                    phaseNum++;
//                } else if ([self.items count] == 0){
//                    [self addItem:kItemNameShuriken];
//                }
            }
            break;
            
        case NJTutorialPhasePickupMedikit:
            if (((NJPlayer*)self.players[0]).ninja.health == FULL_HP) {
                [self toggleControl];
                phaseNum++;
            }
            break;
            
        case NJTutorialPhaseUseIce:
            if (!((NJPlayer*)self.players[1]).item) {
                if (((NJPlayer*)self.players[1]).ninja.frozenCount > 0){
                    [self toggleControl];
                    phaseNum++;
                } else if ([self.items count] == 0 && !((NJPlayer*)self.players[0]).item) {
                    [self addItem:kItemNameIceScroll];
                }
            }

            break;

        default:
            break;
    }
    
    if (((NJPlayer*)self.players[1]).ninja.health <FULL_HP) {
        ((NJPlayer*)self.players[1]).ninja.health = FULL_HP;
    }
}



#pragma delegate method
- (void)nextButton:(NJTuTorialNextButton *) button touchesEnded:(NSSet *)touches{
    if (button == self.nextButton) {
        switch (phaseNum) {
            case NJTutorialPhaseIntro:
                [self toggleControl];
                phaseNum++;
                break;
                
            case NJTutorialPhaseIntroToAttack:
                [self toggleControl];
                phaseNum++;
                break;
            
            case NJTutorialPhaseIntroToPickupShuriken:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameShuriken];
                break;
                
            case NJTutorialPhaseIntroToUseShuriken:
                [self toggleControl];
                phaseNum++;
                break;
 
            case NJTutorialPhaseIntroToMedikit:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameMedikit];
                ((NJPlayer*)self.players[0]).ninja.health -= 40;
                break;
                
            case NJTutorialPhaseIntroToIce:
                [self toggleControl];
                phaseNum++;
                [self addItem:kItemNameIceScroll];
                break;
            
            default:
                break;
        }
        
        
        
    }
}


@end

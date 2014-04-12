//
//  NJConstants.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 9/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#pragma mark - Game World
#define kNumOfFramesToSpawnItem 200
#define NJWoodPileInitialImpluse 3
#define FRAME CGRectMake(1024/2, 768/2, 1024, 768)

#pragma mark - Ninja Characters
#define FULL_HP 100

#define kNinjaOneColor [SKColor colorWithRed:1 green:0.3 blue:0 alpha:1]
#define kNinjaTwoColor [SKColor colorWithRed:0.2 green:0.6 blue:1 alpha:1]
#define kNinjaThreeColor [SKColor colorWithRed:1 green:1 blue:0 alpha:1]
#define kNinjaFourColor [SKColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define shadowImageName @"shadow"

#pragma mark - Special Items
#define kAttackDamage 20
#define kThunderScrollDamage 10
#define kWindScrollDamage 10
#define kFireScrollDamage 10
#define kShurikenDamage 10
#define kMineDamage 20
#define kIndicatorAlpha 0.1
#define kThunderScrollFileName @"thunderScroll"
#define kWindScrollFileName @"windScroll"
#define kIceScrollFileName @"iceScroll"
#define kFireScrollFileName @"fireScroll"
#define kMineFileName @"mine"
#define kShurikenFileName @"shuriken"
#define kMedikitFileName @"medikit"

#pragma mark - Music
#define kMusicPatrit @"patrit"
#define kMusicWater @"water"
#define kMusicShadow @"shadowNinja"
#define kMusicFunny @"funnyday"
#define kMusicSun @"sunshining"

#pragma mark - Mode Selection
#define KTutorialModeBtnFileName @"tutorialBtn"
#define kBeginnerModeBtnFileName @"beginnerBtn"
#define kSurvivalModeBtnFilename @"survivalBtn"
#define kModeSelectionBackground @"selectionBG"
#define kModeSelectionBarFilename @"banner"

typedef enum : uint8_t {
    NJGameModeBeginner=0,
    NJGameModeSurvival,
    NJGameModeOneVsThree,
    NJGameModeCount
} NJGameMode;

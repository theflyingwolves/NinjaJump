//
//  NJConstants.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 9/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#pragma mark - Game World
#define kNumOfFramesToSpawnItem 10
#define NJWoodPileInitialImpluse 3

#pragma mark - Ninja Characters
#define FULL_HP 100

#pragma mark - Special Items
#define kAttackDamage 20
#define kThunderScrollDamage 10
#define kWindScrollDamage 10
#define kFireScrollDamage 10
#define kShurikenDamage 10
#define kMineDamage 20
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

typedef enum : uint8_t {
    NJGameModeBeginner=0,
    NJGameModeTutorial,
    NJGameModeSurvival,
    NJGameModeOneVsThree,
    NJGameModeCount
} NJGameMode;

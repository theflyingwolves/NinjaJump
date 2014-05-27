//
//  NJConstants.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 9/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//
/*
 Defines the set of commonly used constatns for the whole game
 Note that some of the constants that are very specific to a certain class will still be declared in its corresponding class, rather than being specified here
 */

#pragma mark - Game World

#define GameWorld @"world"
#define kTimeAddItemToBoss 5.0f
#define NJWoodPileInitialImpluse 3
#define MINIMUM_VELOCITY 1
#define FRAME CGRectMake(1024/2, 768/2, 1024, 768)
#define kBackgroundFileName @"lakeMoonBG"
#define NJButtonJump @"jumpButton"
#define NJButtonItemControl @"itemControl"
#define NJWoodPileImageName @"woodPile"

#pragma mark - Ninja Characters
//#define FULL_HP 100

#define kNinjaOneColor [SKColor colorWithRed:1 green:0.3 blue:0 alpha:1]
#define kNinjaTwoColor [SKColor colorWithRed:0.2 green:0.6 blue:1 alpha:1]
#define kNinjaThreeColor [SKColor colorWithRed:1 green:1 blue:0 alpha:1]
#define kNinjaFourColor [SKColor colorWithRed:0.5 green:0 blue:1 alpha:1]
#define kNinjaColorBlendFactor 0.6
#define shadowImageName @"shadow"

#pragma mark - Special Items
#define kAttackDamage 20
#define kThunderScrollDamage 10
#define kWindScrollDamage 10
#define kFireScrollDamage 10
#define kShurikenDamage 10
#define kMineDamage 20
#define kIndicatorAlpha 0.1
#define kThunderIndicator @"indicator_thunder"
#define kFireIndicator @"indicator_fire"
#define kWindIndicator @"indicator_wind"
#define kIceIndicator @"indicator_ice"

#define kNinjaImageName @"ninja"
#define kBossNinjaImageName @"ninjaBoss"
#define bossIndex @"bossIndex"

#define kThunderScrollFileName @"thunderScroll"
#define kWindScrollFileName @"windScroll"
#define kIceScrollFileName @"iceScroll"
#define kFireScrollFileName @"fireScroll"
#define kMineFileName @"mine"
#define kShurikenFileName @"shuriken"
#define kMedikitFileName @"medikit"
#define itemShadowImageName @"itemShadow"

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
#define kOneVSThreeModeBtnFileName @"oneVSThreeBtn"
#define kModeSelectionBarFilename @"banner"
#define kTutorialModeBtnFileName @"tutorialBtn"
#define kSettingBtnFileName @"settingBtn"
#define kModeSelectionSceneTitle @"mainTitle"
#define kFacebookBtnFileName @"facebookBtn"

#pragma mark - Player Selection
#define kShurikenButtons @"ready buttons"
#define kShurikenShade @"shade"
#define kStartButton @"start button"
#define kShurikenButtonBlue @"touched button blue"
#define kShurikenButtonOrange @"touched button orange"
#define kShurikenButtonPurple @"touched button purple"
#define kShurikenButtonYellow @"touched button yellow"
#define kHaloOrange @"orangeHalo"
#define kHaloBlue @"blueHalo"
#define kHaloYellow @"yellowHalo"
#define kHaloPurple @"purpleHalo"
#define kSelectedOrange @"selectedOrange"
#define kSelectedBlue @"selectedBlue"
#define kSelectedYellow @"selectedYellow"
#define kSelectedPurple @"selectedPurple"
#define kUnselectedOrange @"unselectedOrange"
#define kUnselectedBlue @"unselectedBlue"
#define kUnselectedYellow @"unselectedYellow"
#define kUnselectedPurple @"unselectedPurple"
#define kButtonHaloShinningTime 0.2
#define kShurikenBUttonsFadeoutDuration 1.0

#pragma mark - Control
#define kHomeBtn @"home button"
#define kRestartBtn @"restart button"
#define kResumeBtn @"resume button"
#define kPauseShade @"pauseShade"
#define kButtonColorBlendFactor 0.5
#define kGameBoardRadius 170

#pragma mark - Notification
#define kNotificationPlayerIndex @"activatedPlayerIndex"
#define kNotificationAfterPause @"actionAfterPause"

#pragma mark - AI
#define kAIJumpFrequency 0.5
#define kAIWanderFrequency 0.3
#define kAISurvivalHp 30

typedef enum : uint8_t {
    NJGameModeBeginner=0,
    NJGameModeSurvival,
    NJGameModeOneVsThree,
    NJGameModeTutorial,
    NJGameModeCount
} NJGameMode;

typedef enum : uint8_t {
    NJTeamOne = 0,
    NJTeamTwo,
    NJTeamThree,
    NJTeamFour,
    NJTeamCount
} NJTeamId;

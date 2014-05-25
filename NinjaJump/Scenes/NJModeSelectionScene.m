//
//  NJModeSelectionScene.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
 Main Scene of the game after the loading scene has been completed. Allows players to select which mode to enter or enters a tutorial.
 */

#define BUTTON_WIDTH 250.0f
#define GAP 17.0f
#define MODE_SELECTION_BUTTON_ANIM_LENGTH 0.4f
#define SETTING_BUTTON_WIDTH 273.0f
#define SETTING_BUTTON_HEIGHT 141.0f
#define kNumOfSettingElmts 2
#define titleWidth 900

#import "NJModeSelectionScene.h"
#import "NJButton.h"
#import "NJConstants.h"

@interface NJModeSelectionScene () <NJButtonDelegate>
@property NJButton *oneVSThreeMode;
@property NJButton *beginnerMode;
@property NJButton *survivalMode;
@property NJButton *tutorialMode;
@property NJButton *facebookBtn;
@property SKSpriteNode *bar;
@property SKSpriteNode *sideMenu;
@property SKSpriteNode *title;
@property SKSpriteNode *background;
@end

@implementation NJModeSelectionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self initBackground];
        [self initBar];
        [self initOneVSThreeModeButton];
        [self initBeginnerModeButton];
        [self initSurvivalModeButton];
        [self initSideMenu];
        [self initTitle];
        [self showTitle];
    }
    
    return self;
}

- (void)initBackground
{
    _background = [[SKSpriteNode alloc] initWithImageNamed:kModeSelectionBackground];
    _background.position = FRAME.origin;
    [self addChild:_background];
}

- (void)initBar
{
    _bar = [[SKSpriteNode alloc] initWithImageNamed:kModeSelectionBarFilename];
    _bar.alpha = 0.5;
    _bar.yScale = 0.1;
    _bar.position = CGPointMake(FRAME.origin.x, 220);
    [self addChild:_bar];
    [_bar runAction:[SKAction scaleYTo:1.0f duration:0.4f]];
}

- (void)initTitle
{
    _title = [[SKSpriteNode alloc] initWithImageNamed:kModeSelectionSceneTitle];
    _title.position = CGPointMake(-titleWidth/2,FRAME.size.height-150);
    [self addChild:_title];
}

- (void)initSideMenu
{
    _sideMenu = [[SKSpriteNode alloc] init];
    _sideMenu.position = CGPointMake(80, 215);
    _tutorialMode = [[NJButton alloc] initWithImageNamed:KTutorialModeBtnFileName];
    _tutorialMode.delegate = self;
    _tutorialMode.position = CGPointMake(0, 30);
    _tutorialMode.index = NJGameModeTutorial;
    [_sideMenu addChild:_tutorialMode];
    
    _facebookBtn = [[NJButton alloc] initWithImageNamed:kFacebookBtnFileName];
    _facebookBtn.delegate = self;
    _facebookBtn.position = CGPointMake(0, -30);
    _facebookBtn.index = NJGameModeCount;
    [_sideMenu addChild:_facebookBtn];
    
    _sideMenu.alpha = 0;
    [self addChild:_sideMenu];
}

- (void)initBeginnerModeButton
{
    _beginnerMode = [[NJButton alloc] initWithImageNamed:kBeginnerModeBtnFileName];
    _beginnerMode.delegate = self;
    _beginnerMode.index = NJGameModeBeginner;
    _beginnerMode.position = CGPointMake(1350, 220);
    [self addChild:_beginnerMode];
}

- (void)initSurvivalModeButton
{
    _survivalMode = [[NJButton alloc] initWithImageNamed:kSurvivalModeBtnFilename];
    _survivalMode.delegate = self;
    _survivalMode.index = NJGameModeSurvival;
    _survivalMode.position = CGPointMake(1350, 220);
    [self addChild:_survivalMode];
}

- (void)initOneVSThreeModeButton
{
    _oneVSThreeMode = [[NJButton alloc] initWithImageNamed:kOneVSThreeModeBtnFileName];
    _oneVSThreeMode.delegate = self;
    _oneVSThreeMode.index = NJGameModeOneVsThree;
    _oneVSThreeMode.position = CGPointMake(1350, 220);
    [self addChild:_oneVSThreeMode];
}

// EFFECTS: Run the animation of showing the game main title
- (void)showTitle
{
    SKAction *moveInTitle = [SKAction moveToX:titleWidth/2 duration:MODE_SELECTION_BUTTON_ANIM_LENGTH/2];
    moveInTitle.timingMode = SKActionTimingEaseOut;
    [_title runAction:moveInTitle completion:^{
        [self showButtons];
    }];
}

// EFFECTS: Run the animation of showing the buttons
- (void)showButtons
{
    float xMode1V3 = FRAME.size.width - 0.5*BUTTON_WIDTH - 1*GAP;
    SKAction *moveIn1V3 = [SKAction moveToX:xMode1V3 duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveIn1V3.timingMode = SKActionTimingEaseOut;
    
    float xSurvival = FRAME.size.width - 1.5*BUTTON_WIDTH - 2*GAP;
    SKAction *moveInSurvival = [SKAction moveToX:xSurvival duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveInSurvival.timingMode = SKActionTimingEaseOut;
    
    float xBeginner = FRAME.size.width - 2.5*BUTTON_WIDTH - 3*GAP;
    SKAction *moveInBeginner = [SKAction moveToX:xBeginner duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveInBeginner.timingMode = SKActionTimingEaseOut;
    
    [_beginnerMode runAction:moveInBeginner];
    [_survivalMode runAction:moveInSurvival];
    [_oneVSThreeMode runAction:moveIn1V3 completion:^{
        [_sideMenu runAction:[SKAction fadeAlphaTo:1.0 duration:MODE_SELECTION_BUTTON_ANIM_LENGTH]];
    }];
}

- (void)button:(NJButton *)button touchesBegan:(NSSet *)touches
{
    [button setScale:1.05];
}

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches
{
    [button setScale:1.00];
    if (button.index == NJGameModeCount) {
        NSLog(@"facebook detected");
    }else{
        [self.delegate modeSelected:button.index];
    }
}
@end

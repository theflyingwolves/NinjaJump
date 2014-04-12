//
//  NJModeSelectionScene.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//
#define BUTTON_WIDTH 273.0f
#define GAP 20.0f
#define MODE_SELECTION_BUTTON_ANIM_LENGTH 0.4f

#import "NJModeSelectionScene.h"
#import "NJButton.h"
#import "NJConstants.h"

@interface NJModeSelectionScene () <NJButtonDelegate>
@property NJButton *tutorialMode;
@property NJButton *beginnerMode;
@property NJButton *survivalMode;
@property SKSpriteNode *bar;
@property SKSpriteNode *background;
@end

@implementation NJModeSelectionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self initBackground];
        [self initBar];
        [self initTutorialModeButton];
        [self initBeginnerModeButton];
        [self initSurvivalModeButton];
    }
    
    return self;
}

- (void)initBackground
{
//    _background = [[SKSpriteNode alloc] initWithImageNamed:kModeSelectionBackground];
    _background = [[SKSpriteNode alloc] initWithImageNamed:@"lakeMoonBG"];
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

- (void)initTutorialModeButton
{
    _tutorialMode = [[NJButton alloc] initWithImageNamed:KTutorialModeBtnFileName];
    _tutorialMode.delegate = self;
    //_tutorialMode.index = NJGameModeTutorial;
    _tutorialMode.position = CGPointMake(1350, 220);
    [self addChild:_tutorialMode];
    float x = FRAME.size.width - 2.5*BUTTON_WIDTH - 3*GAP;
    SKAction *moveIn = [SKAction moveToX:x duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveIn.timingMode = SKActionTimingEaseOut;
    [_tutorialMode runAction:moveIn];
}

- (void)initBeginnerModeButton
{
    _beginnerMode = [[NJButton alloc] initWithImageNamed:kBeginnerModeBtnFileName];
    _beginnerMode.delegate = self;
    _beginnerMode.index = NJGameModeBeginner;
    _beginnerMode.position = CGPointMake(1350, 220);
    [self addChild:_beginnerMode];
    float x = FRAME.size.width - 1.5*BUTTON_WIDTH - 2*GAP;
    SKAction *moveIn = [SKAction moveToX:x duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveIn.timingMode = SKActionTimingEaseOut;
    [_beginnerMode runAction:moveIn];
}

- (void)initSurvivalModeButton
{
    _survivalMode = [[NJButton alloc] initWithImageNamed:kSurvivalModeBtnFilename];
    _survivalMode.delegate = self;
    _survivalMode.index = NJGameModeSurvival;
    _survivalMode.position = CGPointMake(1350, 220);
    [self addChild:_survivalMode];
    float x = FRAME.size.width - BUTTON_WIDTH / 2.0f - GAP;
    SKAction *moveIn = [SKAction moveToX:x duration:MODE_SELECTION_BUTTON_ANIM_LENGTH];
    moveIn.timingMode = SKActionTimingEaseOut;
    [_survivalMode runAction:moveIn];
}

- (void)button:(NJButton *)button touchesBegan:(NSSet *)touches
{
    // Nothing to do
}

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches
{
    NSLog(@"Mode selected: %d",button.index);
    [self.delegate modeSelected:button.index];
}
@end

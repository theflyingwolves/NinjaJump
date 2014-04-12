//
//  NJModeSelectionScene.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJModeSelectionScene.h"
#import "NJButton.h"
#import "NJConstants.h"

@interface NJModeSelectionScene () <NJButtonDelegate>
@property NJButton *tutorialMode;
@property NJButton *beginnerMode;
@property NJButton *survivalMode;
@property SKSpriteNode *background;
@end

@implementation NJModeSelectionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        [self initBackground];
        [self initTutorialModeButton];
        [self initBeginnerModeButton];
        [self initSurvivalModeButton];
//        [self addChild:_background];
        [self addChild:_tutorialMode];
        [self addChild:_beginnerMode];
        [self addChild:_survivalMode];
    }
    
    return self;
}

- (void)initBackground
{
    _background = [[SKSpriteNode alloc] initWithImageNamed:kModeSelectionBackground];
}

- (void)initTutorialModeButton
{
    _tutorialMode = [[NJButton alloc] initWithImageNamed:KTutorialModeBtnFileName];
    _tutorialMode.delegate = self;
    _tutorialMode.index = kTutorialModeIndex;
    _tutorialMode.position = CGPointMake(200, 220);
}

- (void)initBeginnerModeButton
{
    _beginnerMode = [[NJButton alloc] initWithImageNamed:kBeginnerModeBtnFileName];
    _beginnerMode.delegate = self;
    _beginnerMode.index = kBeginnerModeIndex;
    _beginnerMode.position = CGPointMake(500, 220);
}

- (void)initSurvivalModeButton
{
    _survivalMode = [[NJButton alloc] initWithImageNamed:kSurvivalModeBtnFilename];
    _survivalMode.delegate = self;
    _survivalMode.index = kSurvivalModeIndex;
    _survivalMode.position = CGPointMake(850, 220);
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

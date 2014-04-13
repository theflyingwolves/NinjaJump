//
//  NJSelectionButtonSystem.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJSelectCharacterButton.h"

@interface NJSelectionButtonSystem : SKSpriteNode

@property (nonatomic) NSMutableArray *selectionButtons;
@property NSMutableArray *activePlayerList;
@property NSArray *haloList;
@property NSArray *unselectedNinjas;
@property NSArray *selectedNinjas;
@property SKSpriteNode *startButton;
@property SKSpriteNode *shade;
@property SKSpriteNode *background;
@property bool isHaloShining;

- (id) init;
- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches;
- (void)stopShining;
- (void)didStartButtonClicked;
- (CGMutablePathRef)pathOfButton:(NJSelectionButtonType)buttonType;
- (void)shineButtons;
- (void)addButtonHalos;
- (void)addSelectionButtons;
- (void)addStartButton;
- (void)addNinjaBackground;
- (void)fireTransition;
- (void)addBackground;
@end

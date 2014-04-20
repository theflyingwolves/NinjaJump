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
//REQUIRES: scene != nil
//MODIFIES: self
//EFFECTS: create an instance of this class, and add it to the scene
//RETURNS: an instance of this class

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches;
//REQUIRES: One of the three NJbutton button touched
//MODIFIES: self
//EFFECTS: response to user press event. specifically, return the selected ninjas to the scene

- (void)stopShining;
//REQUIRES: shinning animation fired at the after initialization
//MODIFIES: self
//EFFECTS: stop the shinning animation

- (void)didStartButtonClicked;
//REQUIRES: start button tarched
//MODIFIES: self
//EFFECTS: drive the scene to start the game

- (CGMutablePathRef)pathOfButton:(NJSelectionButtonType)buttonType;
//EFFECTS: calculate the responsible area of the button passed in
//RETURNS: the responsible area of a button

- (void)shineButtons;
//REQUIRES: selectionButtons != nil
//MODIFIES: selectionButtons
//EFFECTS: run the shinning animation of the selectionButtons

- (void)addButtonHalos;
//REQUIRES: self!=nil
//MODIFIES: self
//EFFECTS: init and add button halos into self

- (void)addSelectionButtons;
//REQUIRES: self!=nil
//MODIFIES: self
//EFFECTS: init and add selection buttons into self

- (void)addStartButton;
//REQUIRES: self!=nil
//MODIFIES: self
//EFFECTS: init and add start button

- (void)addNinjaBackground;
//REQUIRES: self!=nil
//MODIFIES: self
//EFFECTS: init and add the background of each ninja

- (void)fireTransition;
//REQUIRES: self!=nil
//EFFECTS: fire the transition animation after self is initialized

- (void)addBackground;
//REQUIRES: self!=nil
//MODIFIES: self
//EFFECTS: init and add the background of the selection system

@end

//
//  NJModeSelectionScene.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//
/*
 NJModeSelectionScene defines the scene for mode selection of the game. It is where the user can choose to enter differnet game modes.
 */

#import <SpriteKit/SpriteKit.h>
#import "NJConstants.h"

@protocol NJModeSelectionSceneDelegate <NSObject>
// EFFECTS: Handler called after a mode has been selected. Delegate should initialize the game mode identified by the parameter mode
- (void)modeSelected:(NJGameMode)mode;
@end

@interface NJModeSelectionScene : SKScene
@property id<NJModeSelectionSceneDelegate> delegate;
@end

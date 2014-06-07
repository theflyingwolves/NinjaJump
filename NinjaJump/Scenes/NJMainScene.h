//
//  NJMainScene.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 31/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJConstants.h"

@protocol NJMainSceneDelegate <NSObject>
// EFFECTS: Handler called after a mode has been selected. Delegate should initialize the game mode identified by the parameter mode
- (void)mainModeSelected:(NJGameMode)mode;
@end

@interface NJMainScene : SKScene
@property id<NJMainSceneDelegate> delegate;
@end
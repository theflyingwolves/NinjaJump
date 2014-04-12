//
//  NJModeSelectionScene.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

typedef enum {
    kTutorialModeIndex = 0,
    kBeginnerModeIndex,
    kSurvivalModeIndex,
    kTotalNumberOfModes
} modeIndex;

#import <SpriteKit/SpriteKit.h>

@protocol NJModeSelectionSceneDelegate <NSObject>
- (void)modeSelected:(modeIndex)index;
@end

@interface NJModeSelectionScene : SKScene
@property id<NJModeSelectionSceneDelegate> delegate;
@end

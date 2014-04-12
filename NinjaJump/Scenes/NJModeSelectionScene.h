//
//  NJModeSelectionScene.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJConstants.h"

@protocol NJModeSelectionSceneDelegate <NSObject>
- (void)modeSelected:(NJGameMode)mode;
@end

@interface NJModeSelectionScene : SKScene
@property id<NJModeSelectionSceneDelegate> delegate;
@end

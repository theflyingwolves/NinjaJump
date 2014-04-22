//
//  NJPausePanel.h
//  NinjaJump
//
//  Created by Wang Yichao on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NJButton.h"

#define RESTART 0
#define HOME 1
#define RESUME 2

@interface NJPausePanel : SKSpriteNode
@property NJButton *restartBtn;
@property NJButton *homeBtn;
@property NJButton *resumeBtn;
@end

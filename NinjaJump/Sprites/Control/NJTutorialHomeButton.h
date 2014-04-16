//
//  NJTutorialHomeButton.h
//  NinjaJump
//
//  Created by wulifu on 17/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NJTutorialHomeButton;

@protocol NJTuTorialHomeButtonDelegate <NSObject>
- (void)homeButton:(NJTutorialHomeButton *) button touchesEnded:(NSSet *)touches;
@end

@interface NJTutorialHomeButton : SKSpriteNode
@property (nonatomic, weak) id <NJTuTorialHomeButtonDelegate> delegate;
@end

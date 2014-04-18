//
//  NJTutorialHomeButton.h
//  NinjaJump
//
//  Created by wulifu on 17/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
 This class is the home button for the tutorial mode
*/

#import <SpriteKit/SpriteKit.h>

@class NJTutorialHomeButton;

/*
 This protocol delegates the touch event hanlder to another class
*/
@protocol NJTuTorialHomeButtonDelegate <NSObject>
- (void)homeButton:(NJTutorialHomeButton *) button touchesEnded:(NSSet *)touches;
@end

@interface NJTutorialHomeButton : SKSpriteNode
@property (nonatomic, weak) id <NJTuTorialHomeButtonDelegate> delegate;
@end

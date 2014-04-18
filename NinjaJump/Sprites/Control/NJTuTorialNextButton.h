//
//  NJTuTorialNextButton.h
//  NinjaJump
//
//  Created by wulifu on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    This class is the next button for the tutorial mode
*/

#import <SpriteKit/SpriteKit.h>

@class NJTuTorialNextButton;


/* 
    This protocol delegates the touch event hanlder to another class
*/
@protocol NJTuTorialNextButtonDelegate <NSObject>
- (void)nextButton:(NJTuTorialNextButton *) button touchesEnded:(NSSet *)touches;
@end

@interface NJTuTorialNextButton : SKSpriteNode
@property (nonatomic, weak) id <NJTuTorialNextButtonDelegate> delegate;
@end

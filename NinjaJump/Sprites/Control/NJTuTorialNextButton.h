//
//  NJTuTorialNextButton.h
//  NinjaJump
//
//  Created by wulifu on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NJTuTorialNextButton;

@protocol NJTuTorialNextButtonDelegate <NSObject>
- (void)nextButton:(NJTuTorialNextButton *) button touchesEnded:(NSSet *)touches;
@end

@interface NJTuTorialNextButton : SKSpriteNode
@property (nonatomic, weak) id <NJTuTorialNextButtonDelegate> delegate;
@end

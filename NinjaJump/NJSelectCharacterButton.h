//
//  NJSelectCharacterButton.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class NJSelectCharacterButton;
@protocol NJButtonDelegate <NSObject>

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches;

@end

@interface NJSelectCharacterButton : SKSpriteNode

@property (nonatomic, weak) id <NJButtonDelegate> delegate;

@end

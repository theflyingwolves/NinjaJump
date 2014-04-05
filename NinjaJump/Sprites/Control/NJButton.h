//
//  NJButton.h
//  NinjaJump
//
//  Created by Tang Zijian on 22/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class NJButton, NJPlayer;

@protocol NJButtonDelegate <NSObject>

- (void)button:(NJButton *) button touchesBegan:(NSSet *)touches;
- (void)button:(NJButton *) button touchesEnded:(NSSet *)touches;

@end

@interface NJButton : SKSpriteNode

@property (nonatomic, weak) id <NJButtonDelegate> delegate;
@property (nonatomic, weak) NJPlayer *player;

- (id)initWithImageNamed:(NSString *)name;

@end

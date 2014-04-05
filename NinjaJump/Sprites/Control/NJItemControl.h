//
//  NJItemControl.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class NJPlayer,NJItemControl,NJSpecialItem;

@protocol NJItemControlDelegate <NSObject>
- (void)itemControl:(NJItemControl *) button touchesBegan:(NSSet *)touches;
- (void)itemControl:(NJItemControl *) button touchesEnded:(NSSet *)touches;
@end


@interface NJItemControl : SKSpriteNode

@property (nonatomic, weak) id <NJItemControlDelegate> delegate;
@property (nonatomic, weak) NJPlayer *player;
@property (nonatomic, weak) NJSpecialItem *itemHold;

- (id)initWithImageNamed:(NSString *)name;
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;
@end
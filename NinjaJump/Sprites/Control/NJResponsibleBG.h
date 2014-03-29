//
//  NJResponsibleBG.h
//  NinjaJump
//
//  Created by Wang Yichao on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol NJBGclickingDelegate <NSObject>

- (void)backgroundTouchesEnded:(NSSet *)touches;

@end

@interface NJResponsibleBG : SKSpriteNode

@property (nonatomic, weak) id <NJBGclickingDelegate> delegate;

- (id)initWithImageNamed:(NSString *)name;

@end

//
//  NJSpecialItem.h
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NJSpecialItem : SKSpriteNode

@property BOOL isPickedUp;

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position;


@end

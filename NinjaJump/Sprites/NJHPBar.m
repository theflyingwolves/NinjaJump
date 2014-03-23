//
//  NJHPBar.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 23/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#define HP_BAR_IMAGE_NAME @"hp_bar"
#define HP_BAR_BOTTOM_IMAGE_NAME @"hp_bar_bottom"
#define FULL_HP 100

#import "NJHPBar.h"
#import "NJPlayer.h"
#import "NJCharacter.h"
#import "NJNinjaCharacter.h"

@interface NJHPBar()
@property SKCropNode *HPBar;
@property SKSpriteNode *bottomLayer;
@property float healthPoint;
@property NJPlayer *player;
@property SKSpriteNode *maskNode;
@end

@implementation NJHPBar

+ (NJHPBar *)hpBarWithPosition:(CGPoint)position andPlayer:(NJPlayer *)player
{
    NJHPBar *bar = [[NJHPBar alloc] initWithPosition:position];
    bar.player = player;
    return bar;
}

- (NJHPBar *)initWithPosition:(CGPoint)position
{
    self = [super init];
    if (self) {
        if (!_HPBar) {
//            self.position = position;
            _HPBar = [SKCropNode node];
            SKSpriteNode *bar = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_IMAGE_NAME];
            [_HPBar addChild:bar];
            
            SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(250, 250)];
            [_HPBar setMaskNode:mask];
            self.maskNode = mask;
        }
        
        if (!_bottomLayer) {
            _bottomLayer = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_BOTTOM_IMAGE_NAME];
        }
        
        _HPBar.position = position;
        _bottomLayer.position = position;
        
        [self addChild:_bottomLayer];
        [self addChild:_HPBar];
        self.healthPoint = FULL_HP;
    }
    
    return self;
}

- (void)updateHealthPoint
{
    self.healthPoint = self.player.ninja.health;
    float ratio = self.healthPoint / FULL_HP;
//    self.maskNode.anchorPoint = CGPointMake(self.position.x - self.maskNode.size.width / 2, self.position.y - self.maskNode.size.height / 2);
//    NSLog(@"%f, %f", self.position.x, self.position.y);
//    NSLog(@"%f",ratio);
    self.maskNode.xScale = ratio * 0.45;
//    self.maskNode.xScale = 0.4;
//    self.maskNode.yScale = 0.2;
}

@end

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
        self.position = position;
        if (!_HPBar) {
            _HPBar = [SKCropNode node];
            SKSpriteNode *bar = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_IMAGE_NAME];
            [_HPBar addChild:bar];
            
            SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:bar.frame.size];
            mask.position = bar.position;
            mask.position = CGPointMake(mask.position.x + mask.size.width / 2, mask.position.y - mask.size.height / 2);
            [_HPBar setMaskNode:mask];
            mask.anchorPoint = CGPointMake(1, 0);
            [_HPBar setMaskNode:mask];
            self.maskNode = mask;
        }
        
        if (!_bottomLayer) {
            _bottomLayer = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_BOTTOM_IMAGE_NAME];
        }
        
        [self addChild:_bottomLayer];
        [self addChild:_HPBar];
        self.healthPoint = FULL_HP;
    }
    
    return self;
}

- (void)updateHealthPoint
{
    float newHp = self.player.ninja.health;
    float ratio = newHp / FULL_HP;
    self.maskNode.yScale = ratio * 0.8;
    self.healthPoint = newHp;
}

@end

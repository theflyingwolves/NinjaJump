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
#define BASE 0

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
    if (newHp < 0) {
        return;
    }else if(newHp > FULL_HP){
        newHp = FULL_HP;
    }

    float ratio = newHp / FULL_HP;
    [self.maskNode runAction:[SKAction rotateToAngle:M_PI/2*(1-ratio-BASE) duration:1]];
    self.healthPoint = newHp;
}
@end

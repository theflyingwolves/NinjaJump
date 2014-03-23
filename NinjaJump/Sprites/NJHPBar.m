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

@interface NJHPBar()
@property SKCropNode *HPBar;
@property SKSpriteNode *bottomLayer;
@property float healthPoint;
@end

@implementation NJHPBar

+ (NJHPBar *)hpBarWithPosition:(CGPoint)position
{
    NJHPBar *bar = [[NJHPBar alloc] initWithPosition:position];
    return bar;
}

- (NJHPBar *)initWithPosition:(CGPoint)position
{
    self = [super init];
    if (self) {
        if (!_HPBar) {
            _HPBar = [SKCropNode node];
            SKSpriteNode *bar = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_IMAGE_NAME];
            [_HPBar addChild:bar];
            
            SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(200, 200)];
            [_HPBar setMaskNode:mask];
        }
        
        if (!_bottomLayer) {
            _bottomLayer = [SKSpriteNode spriteNodeWithImageNamed:HP_BAR_BOTTOM_IMAGE_NAME];
        }
        
        _HPBar.position = position;
        _bottomLayer.position = position;
        
        [self addChild:_bottomLayer];
        [self addChild:_HPBar];
        
        self.position = position;
        self.healthPoint = FULL_HP;
    }
    
    return self;
}

- (void)applyDamage:(float)amount
{
    if (self.healthPoint > amount) {
        self.healthPoint -= amount;
    }else{
        self.healthPoint = 0;
    }
    
    float ratio = self.healthPoint / FULL_HP;
    
}

@end

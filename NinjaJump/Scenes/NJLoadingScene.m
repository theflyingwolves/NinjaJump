//
//  NJLoadingScene.m
//  NinjaJump
//
//  Created by Tang Zijian on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLoadingScene.h"

static NSString *kLogoImageName = @"logo.png";
static NSString *kLoadingBarBackgroundImageName = @"loading bar.png";
static NSString *kLoadingBarForegroundImageName = @"loading bar2.png";
static NSString *kLightImageName = @"light.png";

@interface NJLoadingScene()
@property (nonatomic) SKSpriteNode *light;
@property (nonatomic) SKSpriteNode *loadingBarBackground;
@property (nonatomic) SKSpriteNode *loadingBarForeground;
@property (nonatomic) SKSpriteNode *logo;
@end

@implementation NJLoadingScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self) {
        _light = [[SKSpriteNode alloc] initWithImageNamed:kLightImageName];
        _light.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _logo = [[SKSpriteNode alloc] initWithImageNamed:kLogoImageName];
        _logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _loadingBarBackground = [[SKSpriteNode alloc] initWithImageNamed:kLoadingBarBackgroundImageName];
        _loadingBarBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/2.5);
        _loadingBarForeground = [[SKSpriteNode alloc] initWithImageNamed:kLoadingBarForegroundImageName];
        _loadingBarForeground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/2.5);
        [self addChild:_light];
        [self addChild:_logo];
        [self addChild:_loadingBarBackground];
        [self addChild:_loadingBarForeground];
        [self shineLogo];
    }
    
    return self;
}

- (void)shineLogo{
    SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.3],[SKAction fadeInWithDuration:0.3]]];
    [_light runAction:[SKAction repeatActionForever:blink]];
}



@end

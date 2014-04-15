//
//  NJPausePanel.m
//  NinjaJump
//
//  Created by Wang Yichao on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPausePanel.h"

#define btnX 150

@interface NJPausePanel ()
@property SKCropNode *pausePanelCrop;
@property SKSpriteNode *pausePanel;
@property SKSpriteNode *mask;
@property SKSpriteNode *backBtn;
@property SKSpriteNode *restartBtn;
@property SKSpriteNode *panelBarLeft;
@property SKSpriteNode *panelBarRight;
@property BOOL isReacted;
@property BOOL isInitDone;
@end

@implementation NJPausePanel

-(id)init{
    self = [super init];
    if (self) {
        self.pausePanelCrop = [[SKCropNode alloc] init];
        self.pausePanel = [[SKSpriteNode alloc] initWithImageNamed:@"pause scene bg"];
        self.mask = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.pausePanel.frame.size];
        self.mask.xScale = 0.05;
        [self.pausePanelCrop addChild:self.pausePanel];
        [self.pausePanelCrop setMaskNode:self.mask];
        
        self.backBtn = [[SKSpriteNode alloc]initWithImageNamed:@"continue button.png"];
        self.restartBtn = [[SKSpriteNode alloc]initWithImageNamed:@"restart button.png"];
        self.panelBarLeft = [[SKSpriteNode alloc] initWithImageNamed:@"pause_scene_left_bar"];
        self.panelBarRight = [[SKSpriteNode alloc] initWithImageNamed:@"pause_scene_right_bar"];
        self.backBtn.position = CGPointMake(btnX, 0);
        self.restartBtn.position = CGPointMake(-btnX, 0);
        
        self.panelBarLeft.position = CGPointMake(-50, 15);
        self.panelBarRight.position = CGPointMake(50, 15);
        
        self.userInteractionEnabled = YES;
        [self.pausePanelCrop addChild:self.backBtn];
        [self.pausePanelCrop addChild:self.restartBtn];
        [self addChild:self.pausePanelCrop];
        [self addChild:self.panelBarLeft];
        [self addChild:self.panelBarRight];
        
        [self.mask runAction:[SKAction scaleXTo:1.0 duration:1.2]];
        [self.panelBarLeft runAction:[SKAction moveToX:-325 duration:0.8]];
        [self.panelBarRight runAction:[SKAction moveToX:325 duration:0.8]];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    CGFloat dist2restartBtn = sqrt((touchPoint.x+btnX)*(touchPoint.x+btnX)+touchPoint.y*touchPoint.y);
    CGFloat dist2backBtn = sqrt((touchPoint.x-btnX)*(touchPoint.x-btnX)+touchPoint.y*touchPoint.y);

    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
    SKAction *scaleUp = [SKAction scaleBy:1.2 duration:0.5];
    SKAction *actionGroup =[SKAction group:@[fadeAway, scaleUp]];
    
    if (dist2restartBtn<60) {
        [self.restartBtn runAction:actionGroup];
        NSNotification *note = [NSNotification notificationWithName:@"actionAfterPause" object:[NSNumber numberWithInt:RESTART]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    } else if (dist2backBtn<60) {
        NSNotification *note = [NSNotification notificationWithName:@"actionAfterPause" object:[NSNumber numberWithInt:BACK]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    } else {
        NSNotification *note = [NSNotification notificationWithName:@"actionAfterPause" object:[NSNumber numberWithInt:CONTINUE]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    }
}

@end

//
//  NJPausePanel.m
//  NinjaJump
//
//  Created by Wang Yichao on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPausePanel.h"

#define btnX 150


@implementation NJPausePanel{
    SKSpriteNode *continueBtn;
    SKSpriteNode *restartBtn;
    bool isReacted;
}

-(id)init{
    self = [super initWithImageNamed:@"pause scene.png"];
    if(self){
        self.userInteractionEnabled = YES;
        continueBtn = [[SKSpriteNode alloc]initWithImageNamed:@"continue button.png"];
        restartBtn = [[SKSpriteNode alloc]initWithImageNamed:@"restart button.png"];
        continueBtn.position = CGPointMake(-btnX, 0);
        restartBtn.position = CGPointMake(btnX, 0);
        [self addChild:continueBtn];
        [self addChild:restartBtn];

    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    NSLog(@"%f %f",touchPoint.x,touchPoint.y);
    CGFloat dist2continueBtn = sqrt((touchPoint.x+btnX)*(touchPoint.x+btnX)+touchPoint.y*touchPoint.y);
    CGFloat dist2restartBtn = sqrt((touchPoint.x-btnX)*(touchPoint.x-btnX)+touchPoint.y*touchPoint.y);
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
    SKAction *scaleUp = [SKAction scaleBy:1.2 duration:0.5];
    SKAction *actionGroup =[SKAction group:@[fadeAway, scaleUp]];
    if (dist2continueBtn<60) {
        [continueBtn runAction:actionGroup];
        NSNotification *note = [NSNotification notificationWithName:@"actionAfterPause" object:[NSNumber numberWithInt:CONTINUE]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        isReacted = YES;
    } else if (dist2restartBtn<60) {
        [restartBtn runAction:actionGroup];
        NSNotification *note = [NSNotification notificationWithName:@"actionAfterPause" object:[NSNumber numberWithInt:RESTART]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        isReacted = YES;
    }
}

@end

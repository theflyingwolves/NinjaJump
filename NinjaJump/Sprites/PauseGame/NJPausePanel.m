//
//  NJPausePanel.m
//  NinjaJump
//
//  Created by Wang Yichao on 29/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJPausePanel.h"
#import "NJButton.h"
#import "NJConstants.h"

#define kBtnY 100

@interface NJPausePanel () <NJButtonDelegate>
@property SKSpriteNode *shade;
@property BOOL isReacted;     //
@end

@implementation NJPausePanel

-(id)init{
    self = [super init];
    if (self) {
        self.homeBtn = [[NJButton alloc]initWithImageNamed:kHomeBtn];
        self.restartBtn = [[NJButton alloc]initWithImageNamed:kRestartBtn];
        self.resumeBtn = [[NJButton alloc] initWithImageNamed:kResumeBtn];
        self.shade = [SKSpriteNode spriteNodeWithImageNamed:kPauseShade];
        self.homeBtn.position = CGPointMake(0, kBtnY);
        self.restartBtn.position = CGPointMake(0, 0);
        self.resumeBtn.position = CGPointMake(0, -kBtnY);
        [self addChild:self.shade];
        [self addChild:self.homeBtn];
        [self addChild:self.restartBtn];
        [self addChild:self.resumeBtn];
        self.restartBtn.delegate = self;
        self.homeBtn.delegate = self;
        self.resumeBtn.delegate = self;
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)button:(NJButton *)button touchesBegan:(NSSet *)touches{
    
}


//Handles the press event of the three buttons: home button, resume button and restart button
-(void)button:(NJButton *)sender touchesEnded:(NSSet *)touches{
    if (sender == self.restartBtn) {
        NSNotification *note = [NSNotification notificationWithName:kNotificationAfterPause object:[NSNumber numberWithInt:RESTART]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    } else if (sender == self.homeBtn) {
        NSNotification *note = [NSNotification notificationWithName:kNotificationAfterPause object:[NSNumber numberWithInt:HOME]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    } else if (sender == self.resumeBtn){
        NSNotification *note = [NSNotification notificationWithName:kNotificationAfterPause object:[NSNumber numberWithInt:RESUME]];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        [self removeFromParent];
        self.isReacted = YES;
    }
}

@end

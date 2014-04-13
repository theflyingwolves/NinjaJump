//
//  NJBossSelectionSystem.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJ1V3SelectionButtonSystem.h"
#import "NJSelectionButtonSystem.h"
#import "NJConstants.h"

@implementation NJ1V3SelectionButtonSystem

- (id) init{
    self = [super init];
    if (self) {
        self.activePlayerList = [NSMutableArray array];
        [self addNinjaBackground];
        [self addBackground];
        [self addStartButton];
        [self addButtonHalos];
        [self addSelectionButtons];
        [self fireTransition];
        self.isHaloShining = NO;
    }
    return self;
}

- (void)shineAll
{
    for (int i=0; i<4; i++) {
        NJSelectCharacterButton *button = self.selectionButtons[i];
        button.hidden = NO;
        SKSpriteNode *ninja = self.selectedNinjas[i];
        ninja.hidden = NO;
    }
}

- (void)fireTransition
{
    SKAction* rotate = [SKAction rotateByAngle:5*M_PI duration:1];
    SKAction *moveDown = [SKAction moveToY:-10 duration:1];
    SKAction *fadeIn =[SKAction fadeAlphaTo:1 duration:1];
    SKAction *rotateIn = [SKAction group:@[rotate,moveDown]];
    [self.background runAction:rotateIn];
    [self.shade runAction:fadeIn completion:^{
        [self shineAll];
    }];
}

- (void)button:(NJSelectCharacterButton *)button touchesEnded:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    CGFloat dist = sqrt(touchPoint.x*touchPoint.x+touchPoint.y*touchPoint.y);
    bool isReacted = NO;
    CGFloat startButtonRadius = 50;
    for (int i=0; i<4; i++) {
        CGPathRef path= [self pathOfButton:(NJSelectionButtonType)i];
        NJSelectCharacterButton *button = self.selectionButtons[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            [self disselectIndex:self.selectedIndex];
            NSString *bossButtonFileName = @"touched button boss";
            NSString *bossNinjaFileName = @"selectedBoss";
            [button changeBackgroundImageToImageNamed:bossButtonFileName];
            ((SKSpriteNode *)self.selectedNinjas[i]).texture = [SKTexture textureWithImageNamed:bossNinjaFileName];
            self.selectedIndex = i;
        }
        CGPathRelease(path);
    }
    
    if (self.activePlayerList.count>1) {
        self.startButton.hidden = NO;
        if (!isReacted && dist<startButtonRadius) {
            [self didStartButtonClicked];
        }
    } else {
        self.startButton.hidden = YES;
    }
}

- (void)disselectIndex:(int)index
{
    SKSpriteNode *selectedBackground = self.selectedNinjas[index];
    NJSelectCharacterButton *selectedButton = self.selectionButtons[index];
    NSString *buttonFileName;
    NSString *backgroundFileName;
    
    switch (index) {
        case YELLOW:
            buttonFileName = kShurikenButtonYellow;
            backgroundFileName = kSelectedYellow;
            break;
        case ORANGE:
            buttonFileName = kShurikenButtonOrange;
            backgroundFileName = kSelectedOrange;
            break;
        case BLUE:
            buttonFileName = kShurikenButtonBlue;
            backgroundFileName = kSelectedBlue;
            break;
        case PURPLE:
            buttonFileName = kShurikenButtonPurple;
            backgroundFileName = kSelectedPurple;
            break;
        default:
            break;
    }
    
    [selectedButton changeBackgroundImageToImageNamed:buttonFileName];
    selectedBackground.texture = [SKTexture textureWithImageNamed:backgroundFileName];
}
@end

//
//  NJBossSelectionSystem.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
 Boss Selection System for 1V3Mode.
 */

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
        self.selectedIndex = -1;
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
        [self shineButtons];
        self.startButton.hidden = NO;
    }];
}

- (void)addStartButton
{
    [super addStartButton];
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
            if (self.isHaloShining) {
                [self stopShining];
            }
            if (self.selectedIndex >= 0) {
                [self disselectIndex:self.selectedIndex];
            }
            NSString *bossButtonFileName = [self determineButtonFileName:i];
            NSString *bossNinjaFileName = [self determineNinjaFileName:i];
            
            [button changeBackgroundImageToImageNamed:bossButtonFileName];
            ((SKSpriteNode *)self.selectedNinjas[i]).texture = [SKTexture textureWithImageNamed:bossNinjaFileName];
            self.selectedIndex = i;
            button.isSelected = !button.isSelected;
            SKSpriteNode *buttonHalo = self.haloList[i];
            buttonHalo.alpha = 1.0 - buttonHalo.alpha;
            isReacted = YES;
        }
        CGPathRelease(path);
    }
    
    if (!isReacted && dist<startButtonRadius && self.selectedIndex != -1) {
        [self didStartButtonClicked];
    }
}

- (void)shineButtons {
    if (!self.selectedIndex) { //Check no player selected
        
        SKAction *appear = [SKAction fadeInWithDuration:0.05];
        SKAction *disappear = [SKAction fadeOutWithDuration:0.05];
        SKAction *keeplighting = [SKAction waitForDuration:kButtonHaloShinningTime];
        SKAction *wait = [SKAction waitForDuration:3*(kButtonHaloShinningTime+0.1)];
        SKAction *flash = [SKAction sequence:@[appear,keeplighting,disappear, wait]];
        
        SKAction *flashRepeatly = [SKAction repeatActionForever:flash];
        for (int i=0; i<4; i++) {
            float waitDuration = i*(kButtonHaloShinningTime+0.1);
            SKSpriteNode *halo = self.haloList[i];
            SKAction *wait = [SKAction waitForDuration:waitDuration];
            SKAction *sequence = [SKAction sequence:@[wait,flashRepeatly]];
            [halo runAction:sequence];
        }
        self.isHaloShining = YES;
    }
}

- (NSString *)determineButtonFileName:(int)index
{
    return [NSString stringWithFormat:@"touched button boss 0%d",index];
}

- (NSString *)determineNinjaFileName:(int)index
{
    return [NSString stringWithFormat:@"selectedBoss_0%d",index];
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
    SKSpriteNode *buttonHalo = self.haloList[index];
    buttonHalo.alpha = 1.0 - buttonHalo.alpha;

}

- (void)didStartButtonClicked
{
    SKAction *flyAway2TopLeft = [SKAction moveByX:-700 y:700 duration:1.0];
    SKAction *flyAway2BottomLeft = [SKAction moveByX:-700 y:-700 duration:1.0];
    SKAction *flyAway2BottomRight = [SKAction moveByX:700 y:-700 duration:1.0];
    SKAction *flyAway2TopRight = [SKAction moveByX:700 y:700 duration:1.0];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    [self.selectionButtons[0] runAction:flyAway2BottomLeft];
    [self.selectionButtons[1] runAction:flyAway2BottomRight];
    [self.selectionButtons[2] runAction:flyAway2TopRight];
    [self.selectionButtons[3] runAction:flyAway2TopLeft];
    NSNotification *note = [NSNotification notificationWithName:kNotificationPlayerIndex object:[self constructNoteArray]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    [self runAction:sequence];
}

- (NSArray *)constructNoteArray
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSNumber numberWithInt:self.selectedIndex]];
    
    for (int i=0; i<4; i++) {
        if (i != self.selectedIndex) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return array;
}
@end

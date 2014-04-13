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

- (void)addStartButton
{
    [super addStartButton];
    self.startButton.hidden = NO;
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
            NSString *bossButtonFileName = [self determineButtonFileName:i];
            NSString *bossNinjaFileName = [self determineNinjaFileName:i];
            
            [button changeBackgroundImageToImageNamed:bossButtonFileName];
            ((SKSpriteNode *)self.selectedNinjas[i]).texture = [SKTexture textureWithImageNamed:bossNinjaFileName];
            self.selectedIndex = i;
            button.isSelected = !button.isSelected;
            isReacted = YES;
//            NSNumber *index = [NSNumber numberWithInt:i];
//            if (button.isSelected) {
//                [self.activePlayerList removeObject:index];
//                NSLog(@"adding index: %d",i);
//            } else if(![self.activePlayerList containsObject:index]){
//                [self.activePlayerList addObject:index];
//                NSLog(@"removing index: %d",i);
//            }
        }
        CGPathRelease(path);
    }
    
    if (!isReacted && dist<startButtonRadius) {
        [self didStartButtonClicked];
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
}

- (void)didStartButtonClicked
{
    //NSLog(@"game start");
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

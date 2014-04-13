//
//  NJSelectionButtonSystem.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectionButtonSystem.h"
#import "NJConstants.h"

@interface NJSelectionButtonSystem() <NJSelectionButtonDelegate>
@end

@implementation NJSelectionButtonSystem{
    NSMutableArray *selectionButtons;
    NSMutableArray *activePlayerList;
    NSArray *haloList;
    NSArray *unselectedNinjas;
    NSArray *selectedNinjas;
    SKSpriteNode *startButton;
    SKSpriteNode *shade;
    SKSpriteNode *background;
    bool isHaloShining;
}

- (id) init{
    self = [super init];
    if (self) {
        activePlayerList = [NSMutableArray array];
        [self addNinjaBackground];
        [self addBackground];
        [self addStartButton];
        [self addButtonHalos];
        [self addSelectionButtons];
        //[self addSpotlight];
        [self fireTransition];
        isHaloShining = NO;
    }
    return self;
}

- (void)addBackground{
    background = [SKSpriteNode spriteNodeWithImageNamed:kShurikenButtons];
    [self addChild:background];
}

- (void)fireTransition{
    SKAction* rotate = [SKAction rotateByAngle:5*M_PI duration:1];
    SKAction *moveDown = [SKAction moveToY:-10 duration:1];
    SKAction *fadeIn =[SKAction fadeAlphaTo:1 duration:1];
    SKAction *rotateIn = [SKAction group:@[rotate,moveDown]];
    [background runAction:rotateIn];
    [shade runAction:fadeIn completion:^{
        [self shineButtons];
    }];
}

- (void)addNinjaBackground {
    SKSpriteNode *unselectedOrange = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedOrange];
    unselectedOrange.position = CGPointMake(-1024/4, -768/4);
    SKSpriteNode *unselectedBlue = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedBlue];
    unselectedBlue.position = CGPointMake(1024/4, -768/4);
    SKSpriteNode *unselectedYellow = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedYellow];
    unselectedYellow.position = CGPointMake(1024/4, 768/4);
    SKSpriteNode *unselectedPurple = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedPurple];
    unselectedPurple.position = CGPointMake(-1024/4, 768/4);
    unselectedNinjas = [NSArray arrayWithObjects:unselectedOrange, unselectedBlue, unselectedYellow, unselectedPurple, nil];
    SKSpriteNode *selectedOrange = [SKSpriteNode spriteNodeWithImageNamed:kSelectedOrange];
    selectedOrange.position = CGPointMake(-1024/4, -768/4);
    SKSpriteNode *selectedBlue = [SKSpriteNode spriteNodeWithImageNamed:kSelectedBlue];
    selectedBlue.position = CGPointMake(1024/4, -768/4);
    SKSpriteNode *selectedYellow = [SKSpriteNode spriteNodeWithImageNamed:kSelectedYellow];
    selectedYellow.position = CGPointMake(1024/4, 768/4);
    SKSpriteNode *selectedPurple = [SKSpriteNode spriteNodeWithImageNamed:kSelectedPurple];
    selectedPurple.position = CGPointMake(-1024/4, 768/4);
    selectedNinjas = [NSArray arrayWithObjects:selectedOrange, selectedBlue, selectedYellow, selectedPurple, nil];
    for (SKSpriteNode *unselected in unselectedNinjas) {
        [self addChild:unselected];
    }
    for (SKSpriteNode *selected in selectedNinjas) {
        [self addChild:selected];
        selected.hidden = YES;
    }
}

- (void)addStartButton{
    startButton = [SKSpriteNode spriteNodeWithImageNamed:kStartButton];
    shade = [SKSpriteNode spriteNodeWithImageNamed:kShurikenShade];
    startButton.hidden = YES;
    startButton.position=CGPointMake(-5, 0);
    shade.alpha = 0;
    [self addChild:shade];
    [self addChild:startButton];
}


- (void)addSelectionButtons {
    NJSelectCharacterButton *selectionButtonOrange = [[NJSelectCharacterButton alloc] initWithType:ORANGE];
//    selectionButtonOrange.position = CGPointMake(-19, 0);
    NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
//    selectionButtonBlue.position = CGPointMake(0, 0);
    NJSelectCharacterButton *selectionButtonYellow = [[NJSelectCharacterButton alloc] initWithType:YELLOW];
//    selectionButtonYellow.position = CGPointMake(-26, 0);
    NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
//    selectionButtonPurple.position = CGPointMake(1, 0);
    selectionButtons = [NSMutableArray arrayWithObjects:selectionButtonOrange, selectionButtonBlue, selectionButtonYellow, selectionButtonPurple, nil];
    for (NJSelectCharacterButton *selectionButton in selectionButtons) {
        selectionButton.hidden = YES;
        selectionButton.delegate = self;
        [self addChild:selectionButton];
    }
}

- (void)addButtonHalos {
    SKSpriteNode *orangeHalo = [SKSpriteNode spriteNodeWithImageNamed:kHaloOrange];
    SKSpriteNode *blueHalo = [SKSpriteNode spriteNodeWithImageNamed:kHaloBlue];
    SKSpriteNode *yellowHalo = [SKSpriteNode spriteNodeWithImageNamed:kHaloYellow];
    SKSpriteNode *purpleHalo = [SKSpriteNode spriteNodeWithImageNamed:kHaloPurple];
    haloList = [NSArray arrayWithObjects: orangeHalo, blueHalo, yellowHalo, purpleHalo, nil];
    for (SKSpriteNode *halo in haloList) {
        [self addChild:halo];
        halo.position = CGPointMake(0, -4);
        halo.alpha = 0;
    }
    
}

- (void)shineButtons {
    if (activePlayerList.count == 0) { //Check no player selected
        
        SKAction *appear = [SKAction fadeInWithDuration:0.05];
        SKAction *disappear = [SKAction fadeOutWithDuration:0.05];
        SKAction *keeplighting = [SKAction waitForDuration:kButtonHaloShinningTime];
        SKAction *wait = [SKAction waitForDuration:3*(kButtonHaloShinningTime+0.1)];
        SKAction *flash = [SKAction sequence:@[appear,keeplighting,disappear, wait]];
        
        SKAction *flashRepeatly = [SKAction repeatActionForever:flash];
        for (int i=0; i<4; i++) {
            float waitDuration = i*(kButtonHaloShinningTime+0.1);
            SKSpriteNode *halo = haloList[i];
            SKAction *wait = [SKAction waitForDuration:waitDuration];
            SKAction *sequence = [SKAction sequence:@[wait,flashRepeatly]];
            [halo runAction:sequence];
        }
        isHaloShining = YES;
        NSLog(@"begin shining");
        
    }
}

- (void)stopShining {
    for (SKSpriteNode *halo in haloList) {
        [halo removeAllActions];
        halo.alpha = 0.0;
    }
    isHaloShining = false;
    NSLog(@"stop shining");
}

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    CGFloat dist = sqrt(touchPoint.x*touchPoint.x+touchPoint.y*touchPoint.y);
    bool isReacted = NO;
    CGFloat startButtonRadius = 50;
    for (int i=0; i<4; i++) {
        CGPathRef path= [self pathOfButton:(NJSelectionButtonType)i];
        NJSelectCharacterButton *button = selectionButtons[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            if (isHaloShining) {
                [self stopShining];
            }
            button.hidden = !button.hidden;
            SKSpriteNode *selected = selectedNinjas[i];
            selected.hidden = !selected.hidden;
            SKSpriteNode *buttonHalo = haloList[i];
            buttonHalo.alpha = 1.0 - buttonHalo.alpha;
            isReacted = YES;
            NSNumber *index = [NSNumber numberWithInt:i];
            if (button.hidden) {
                [activePlayerList removeObject:index];
            } else if(![activePlayerList containsObject:index]){
                [activePlayerList addObject:index];
            }
        }
        CGPathRelease(path);
    }
    //NSLog(@"touchPoint %f",dist);
    if (activePlayerList.count>1) {
        startButton.hidden = NO;
        if (!isReacted && dist<startButtonRadius) {
            [self didStartButtonClicked];
        }
    } else {
        startButton.hidden = YES;
    }
    
}

- (void)didStartButtonClicked{
    //NSLog(@"game start");
    SKAction *flyAway2TopLeft = [SKAction moveByX:-700 y:700 duration:1.0];
    SKAction *flyAway2BottomLeft = [SKAction moveByX:-700 y:-700 duration:1.0];
    SKAction *flyAway2BottomRight = [SKAction moveByX:700 y:-700 duration:1.0];
    SKAction *flyAway2TopRight = [SKAction moveByX:700 y:700 duration:1.0];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    [selectionButtons[0] runAction:flyAway2BottomLeft];
    [selectionButtons[1] runAction:flyAway2BottomRight];
    [selectionButtons[2] runAction:flyAway2TopRight];
    [selectionButtons[3] runAction:flyAway2TopLeft];
    NSNotification *note = [NSNotification notificationWithName:kNotificationPlayerIndex object:[activePlayerList copy]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    [self runAction:sequence];
}

- (CGMutablePathRef)pathOfButton:(NJSelectionButtonType)buttonType{
    CGMutablePathRef path = CGPathCreateMutable();
    switch (buttonType) {
        case ORANGE:
            CGPathMoveToPoint(path, NULL, -5, -80);
            CGPathAddLineToPoint(path, NULL, -160, -200);
            CGPathAddLineToPoint(path, NULL, -150, -5);
            break;
        case BLUE:
            CGPathMoveToPoint(path, NULL, 5, -130);
            CGPathAddLineToPoint(path, NULL, 220, -170);
            CGPathAddLineToPoint(path, NULL, 150, -5);
            break;
        case YELLOW:
            CGPathMoveToPoint(path, NULL, 5, 130);
            CGPathAddLineToPoint(path, NULL, 220, 170);
            CGPathAddLineToPoint(path, NULL, 150, 5);
            break;
        case PURPLE:
            CGPathMoveToPoint(path, NULL, -5, 80);
            CGPathAddLineToPoint(path, NULL, -150, 170);
            CGPathAddLineToPoint(path, NULL, -80, 5);
            break;
        default:
            break;
    }
    CGPathCloseSubpath(path);
    return path;
}

//- (void)addSpotlight{
//    spotLightList = [NSMutableArray array];
//    for (int i=0; i<4; i++) {
//        SKSpriteNode *spotLight = [SKSpriteNode spriteNodeWithImageNamed:@"spotlight.png"];
//        spotLight.hidden = YES;
//        [spotLightList addObject:spotLight];
//    }
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat r = 90.0f;
//    ((SKSpriteNode *)spotLightList[0]).position = CGPointMake(r-screenHeight/2, screenWidth/2-r);
//    ((SKSpriteNode *)spotLightList[0]).xScale = -1;
//    ((SKSpriteNode *)spotLightList[1]).position = CGPointMake(r-screenHeight/2, r-screenWidth/2);
//    ((SKSpriteNode *)spotLightList[1]).xScale = -1;
//    ((SKSpriteNode *)spotLightList[1]).yScale = -1;
//    ((SKSpriteNode *)spotLightList[2]).position = CGPointMake(screenHeight/2-r, r-screenWidth/2);
//    ((SKSpriteNode *)spotLightList[2]).yScale = -1;
//    ((SKSpriteNode *)spotLightList[3]).position = CGPointMake(screenHeight/2-r, screenWidth/2-r);
//
//    //NSLog(@"%lu",spotLightList.count);
//    for (int i=0; i<spotLightList.count; i++) {
//        [self addChild:spotLightList[i]];
//    }
//}

@end
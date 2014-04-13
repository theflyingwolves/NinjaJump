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

@implementation NJSelectionButtonSystem
//{
//    NSMutableArray *selectionButtons;
//    NSMutableArray *activePlayerList;
//    NSArray *haloList;
//    NSArray *unselectedNinjas;
//    NSArray *selectedNinjas;
//    SKSpriteNode *startButton;
//    SKSpriteNode *shade;
//    SKSpriteNode *background;
//    bool isHaloShining;
//}

- (id) init{
    self = [super init];
    if (self) {
        _activePlayerList = [NSMutableArray array];
        [self addNinjaBackground];
        [self addBackground];
        [self addStartButton];
        [self addButtonHalos];
        [self addSelectionButtons];
        //[self addSpotlight];
        [self fireTransition];
        _isHaloShining = NO;
    }
    return self;
}

- (void)addBackground{
    _background = [SKSpriteNode spriteNodeWithImageNamed:kShurikenButtons];
    [self addChild:_background];
}

- (void)fireTransition{
    SKAction* rotate = [SKAction rotateByAngle:5*M_PI duration:1];
    SKAction *moveDown = [SKAction moveToY:-10 duration:1];
    SKAction *fadeIn =[SKAction fadeAlphaTo:1 duration:1];
    SKAction *rotateIn = [SKAction group:@[rotate,moveDown]];
    [_background runAction:rotateIn];
    [_shade runAction:fadeIn completion:^{
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
    _unselectedNinjas = [NSArray arrayWithObjects:unselectedOrange, unselectedBlue, unselectedYellow, unselectedPurple, nil];
    SKSpriteNode *selectedOrange = [SKSpriteNode spriteNodeWithImageNamed:kSelectedOrange];
    selectedOrange.position = CGPointMake(-1024/4, -768/4);
    SKSpriteNode *selectedBlue = [SKSpriteNode spriteNodeWithImageNamed:kSelectedBlue];
    selectedBlue.position = CGPointMake(1024/4, -768/4);
    SKSpriteNode *selectedYellow = [SKSpriteNode spriteNodeWithImageNamed:kSelectedYellow];
    selectedYellow.position = CGPointMake(1024/4, 768/4);
    SKSpriteNode *selectedPurple = [SKSpriteNode spriteNodeWithImageNamed:kSelectedPurple];
    selectedPurple.position = CGPointMake(-1024/4, 768/4);
    _selectedNinjas = [NSArray arrayWithObjects:selectedOrange, selectedBlue, selectedYellow, selectedPurple, nil];
    for (SKSpriteNode *unselected in _unselectedNinjas) {
        [self addChild:unselected];
    }
    for (SKSpriteNode *selected in _selectedNinjas) {
        [self addChild:selected];
        selected.hidden = YES;
    }
}

- (void)addStartButton{
    _startButton = [SKSpriteNode spriteNodeWithImageNamed:kStartButton];
    _shade = [SKSpriteNode spriteNodeWithImageNamed:kShurikenShade];
    _startButton.hidden = YES;
    _startButton.position=CGPointMake(-5, 0);
    _shade.alpha = 0;
    [self addChild:_shade];
    [self addChild:_startButton];
}


- (void)addSelectionButtons {
    NJSelectCharacterButton *selectionButtonOrange = [[NJSelectCharacterButton alloc] initWithType:ORANGE];
    selectionButtonOrange.isSelected = NO;
//    selectionButtonOrange.position = CGPointMake(-19, 0);
    NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
    selectionButtonBlue.isSelected = NO;
//    selectionButtonBlue.position = CGPointMake(0, 0);
    NJSelectCharacterButton *selectionButtonYellow = [[NJSelectCharacterButton alloc] initWithType:YELLOW];
    selectionButtonYellow.isSelected = NO;
//    selectionButtonYellow.position = CGPointMake(-26, 0);
    NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
    selectionButtonPurple.isSelected = NO;
//    selectionButtonPurple.position = CGPointMake(1, 0);
    _selectionButtons = [NSMutableArray arrayWithObjects:selectionButtonOrange, selectionButtonBlue, selectionButtonYellow, selectionButtonPurple, nil];
    for (NJSelectCharacterButton *selectionButton in _selectionButtons) {
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
    _haloList = [NSArray arrayWithObjects: orangeHalo, blueHalo, yellowHalo, purpleHalo, nil];
    for (SKSpriteNode *halo in _haloList) {
        [self addChild:halo];
        halo.position = CGPointMake(0, -4);
        halo.alpha = 0;
    }
    
}

- (void)shineButtons {
    if (_activePlayerList.count == 0) { //Check no player selected
        
        SKAction *appear = [SKAction fadeInWithDuration:0.05];
        SKAction *disappear = [SKAction fadeOutWithDuration:0.05];
        SKAction *keeplighting = [SKAction waitForDuration:kButtonHaloShinningTime];
        SKAction *wait = [SKAction waitForDuration:3*(kButtonHaloShinningTime+0.1)];
        SKAction *flash = [SKAction sequence:@[appear,keeplighting,disappear, wait]];
        
        SKAction *flashRepeatly = [SKAction repeatActionForever:flash];
        for (int i=0; i<4; i++) {
            float waitDuration = i*(kButtonHaloShinningTime+0.1);
            SKSpriteNode *halo = _haloList[i];
            SKAction *wait = [SKAction waitForDuration:waitDuration];
            SKAction *sequence = [SKAction sequence:@[wait,flashRepeatly]];
            [halo runAction:sequence];
        }
        _isHaloShining = YES;
        NSLog(@"begin shining");
        
    }
}

- (void)stopShining {
    for (SKSpriteNode *halo in _haloList) {
        [halo removeAllActions];
        halo.alpha = 0.0;
    }
    _isHaloShining = false;
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
        NJSelectCharacterButton *button = _selectionButtons[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            if (_isHaloShining) {
                [self stopShining];
            }
            button.hidden = !button.hidden;
            SKSpriteNode *selected = _selectedNinjas[i];
            selected.hidden = !selected.hidden;
            SKSpriteNode *buttonHalo = _haloList[i];
            buttonHalo.alpha = 1.0 - buttonHalo.alpha;
            isReacted = YES;
            NSNumber *index = [NSNumber numberWithInt:i];
            if (button.hidden) {
                [_activePlayerList removeObject:index];
            } else if(![_activePlayerList containsObject:index]){
                [_activePlayerList addObject:index];
            }
        }
        CGPathRelease(path);
    }
    //NSLog(@"touchPoint %f",dist);
    if (_activePlayerList.count>1) {
        _startButton.hidden = NO;
        if (!isReacted && dist<startButtonRadius) {
            [self didStartButtonClicked];
        }
    } else {
        _startButton.hidden = YES;
    }
}

- (void)didStartButtonClicked{
    //NSLog(@"game start");
    [self buttonsFlyOut];
    [self ninjaBGshiftOut];
    [self performSelector:@selector(fadeOut) withObject:nil afterDelay:kShurikenBUttonsFadeoutDuration-0.2];
    NSNotification *note = [NSNotification notificationWithName:kNotificationPlayerIndex object:[activePlayerList copy]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)ninjaBGshiftOut {
    SKAction *shiftDown = [SKAction moveByX:0 y:-700 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftRight = [SKAction moveByX:700 y:0 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftUp = [SKAction moveByX:0 y:700 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftLeft = [SKAction moveByX:-700 y:0 duration:kShurikenBUttonsFadeoutDuration];
    [selectedNinjas[0] runAction:shiftDown];
    [selectedNinjas[1] runAction:shiftRight];
    [selectedNinjas[2] runAction:shiftUp];
    [selectedNinjas[3] runAction:shiftLeft];
    [unselectedNinjas[0] runAction:shiftDown];
    [unselectedNinjas[1] runAction:shiftRight];
    [unselectedNinjas[2] runAction:shiftUp];
    [unselectedNinjas[3] runAction:shiftLeft];
}

- (void)buttonsFlyOut {
    SKAction *flyAway2TopLeft = [SKAction moveByX:-700 y:700 duration:1.0];
    SKAction *flyAway2BottomLeft = [SKAction moveByX:-700 y:-700 duration:1.0];
    SKAction *flyAway2BottomRight = [SKAction moveByX:700 y:-700 duration:1.0];
    SKAction *flyAway2TopRight = [SKAction moveByX:700 y:700 duration:1.0];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    [_selectionButtons[0] runAction:flyAway2BottomLeft];
    [_selectionButtons[1] runAction:flyAway2BottomRight];
    [_selectionButtons[2] runAction:flyAway2TopRight];
    [_selectionButtons[3] runAction:flyAway2TopLeft];
    NSNotification *note = [NSNotification notificationWithName:kNotificationPlayerIndex object:[_activePlayerList copy]];
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
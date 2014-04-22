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

- (id) init{
    self = [super init];
    if (self) {
        _activePlayerList = [NSMutableArray array];
        [self addNinjaBackground];
        [self addBackground];
        [self addStartButton];
        [self addButtonHalos];
        [self addSelectionButtons];
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
    unselectedOrange.position = CGPointMake(-FRAME.size.width/4, -FRAME.size.height/4);
    SKSpriteNode *unselectedBlue = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedBlue];
    unselectedBlue.position = CGPointMake(FRAME.size.width/4, -FRAME.size.height/4);
    SKSpriteNode *unselectedYellow = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedYellow];
    unselectedYellow.position = CGPointMake(FRAME.size.width/4, FRAME.size.height/4);
    SKSpriteNode *unselectedPurple = [SKSpriteNode spriteNodeWithImageNamed:kUnselectedPurple];
    unselectedPurple.position = CGPointMake(-FRAME.size.width/4, FRAME.size.height/4);
    _unselectedNinjas = [NSArray arrayWithObjects:unselectedOrange, unselectedBlue, unselectedYellow, unselectedPurple, nil];
    SKSpriteNode *selectedOrange = [SKSpriteNode spriteNodeWithImageNamed:kSelectedOrange];
    selectedOrange.position = CGPointMake(-FRAME.size.width/4, -FRAME.size.height/4);
    SKSpriteNode *selectedBlue = [SKSpriteNode spriteNodeWithImageNamed:kSelectedBlue];
    selectedBlue.position = CGPointMake(FRAME.size.width/4, -FRAME.size.height/4);
    SKSpriteNode *selectedYellow = [SKSpriteNode spriteNodeWithImageNamed:kSelectedYellow];
    selectedYellow.position = CGPointMake(FRAME.size.width/4, FRAME.size.height/4);
    SKSpriteNode *selectedPurple = [SKSpriteNode spriteNodeWithImageNamed:kSelectedPurple];
    selectedPurple.position = CGPointMake(-FRAME.size.width/4, FRAME.size.height/4);
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
    NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
    selectionButtonBlue.isSelected = NO;
    NJSelectCharacterButton *selectionButtonYellow = [[NJSelectCharacterButton alloc] initWithType:YELLOW];
    selectionButtonYellow.isSelected = NO;
    NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
    selectionButtonOrange.isSelected = NO;
    selectionButtonBlue.isSelected = NO;
    selectionButtonYellow.isSelected = NO;
    selectionButtonPurple.isSelected = NO;
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
    }
}

- (void)stopShining {
    for (SKSpriteNode *halo in _haloList) {
        [halo removeAllActions];
        halo.alpha = 0.0;
    }
    _isHaloShining = false;
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
    NSNotification *note = [NSNotification notificationWithName:kNotificationPlayerIndex object:[_activePlayerList copy]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)ninjaBGshiftOut {
    SKAction *shiftDown = [SKAction moveByX:0 y:-700 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftRight = [SKAction moveByX:700 y:0 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftUp = [SKAction moveByX:0 y:700 duration:kShurikenBUttonsFadeoutDuration];
    SKAction *shiftLeft = [SKAction moveByX:-700 y:0 duration:kShurikenBUttonsFadeoutDuration];
    [_selectedNinjas[0] runAction:shiftDown];
    [_selectedNinjas[1] runAction:shiftRight];
    [_selectedNinjas[2] runAction:shiftUp];
    [_selectedNinjas[3] runAction:shiftLeft];
    [_unselectedNinjas[0] runAction:shiftDown];
    [_unselectedNinjas[1] runAction:shiftRight];
    [_unselectedNinjas[2] runAction:shiftUp];
    [_unselectedNinjas[3] runAction:shiftLeft];
}

- (void)fadeOut
{
    SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    [self runAction:sequence];
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

@end
//
//  NJSelectionButtonSystem.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectionButtonSystem.h"

@interface NJSelectionButtonSystem() <NJSelectionButtonDelegate>
@end

@implementation NJSelectionButtonSystem{
    NSMutableArray *selectionButtons;
    NSMutableArray *spotLightList;
    NSMutableArray *activePlayerList;
    SKSpriteNode *startButton;
    SKSpriteNode *shade;
    SKSpriteNode *background;
}

- (id) init{
    self = [super init];
    if (self) {
        activePlayerList = [NSMutableArray array];
        [self addBackground];
        [self addStartButton];
        [self addSelectionButtons];
        [self addSpotlight];
        [self fireTransition];
    }
    return self;
}

- (void)addBackground{
    background = [SKSpriteNode spriteNodeWithImageNamed:@"ready buttons.png"];
    background.position = CGPointMake(55, 700);
    [self addChild:background];
}

- (void)fireTransition{
    SKAction* rotate = [SKAction rotateByAngle:5*M_PI duration:1];
    SKAction *moveDown = [SKAction moveToY:-10 duration:1];
    SKAction *fadeIn =[SKAction fadeAlphaTo:1 duration:1];
    SKAction *rotateIn = [SKAction group:@[rotate,moveDown]];
    [background runAction:rotateIn];
    [shade runAction:fadeIn];
}

- (void)addStartButton{
    startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start button.png"];
    shade = [SKSpriteNode spriteNodeWithImageNamed:@"shade.png"];
    startButton.position = CGPointMake(30, 0);
    startButton.hidden = YES;
    shade.alpha = 0;
    [self addChild:shade];
    [self addChild:startButton];
}



- (void)addSpotlight{
    spotLightList = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        SKSpriteNode *spotLight = [SKSpriteNode spriteNodeWithImageNamed:@"spotlight.png"];
        spotLight.hidden = YES;
        [spotLightList addObject:spotLight];
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat r = 90.0f;
    ((SKSpriteNode *)spotLightList[0]).position = CGPointMake(r-screenHeight/2, screenWidth/2-r);
    ((SKSpriteNode *)spotLightList[0]).xScale = -1;
    ((SKSpriteNode *)spotLightList[1]).position = CGPointMake(r-screenHeight/2, r-screenWidth/2);
    ((SKSpriteNode *)spotLightList[1]).xScale = -1;
    ((SKSpriteNode *)spotLightList[1]).yScale = -1;
    ((SKSpriteNode *)spotLightList[2]).position = CGPointMake(screenHeight/2-r, r-screenWidth/2);
    ((SKSpriteNode *)spotLightList[2]).yScale = -1;
    ((SKSpriteNode *)spotLightList[3]).position = CGPointMake(screenHeight/2-r, screenWidth/2-r);
    
    //NSLog(@"%lu",spotLightList.count);
    for (int i=0; i<spotLightList.count; i++) {
        [self addChild:spotLightList[i]];
    }
}

- (void)addSelectionButtons{
    NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
    NJSelectCharacterButton *selectionButtonRed = [[NJSelectCharacterButton alloc] initWithType:RED];
    NJSelectCharacterButton *selectionButtonBrown = [[NJSelectCharacterButton alloc] initWithType:BROWN];
    NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
    selectionButtons = [NSMutableArray arrayWithObjects:selectionButtonBlue, selectionButtonRed, selectionButtonBrown, selectionButtonPurple, nil];
    for (NJSelectCharacterButton *selectionButton in selectionButtons) {
        selectionButton.hidden = YES;
        selectionButton.delegate = self;
        [self addChild:selectionButton];
    }
}

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    CGFloat dist = sqrt(touchPoint.x*touchPoint.x+touchPoint.y*touchPoint.y);
    bool isReacted = NO;
    CGFloat startButtonRadius = 50;
    for (int i=0; i<4; i++) {
        CGPathRef path= [self pathOfButton:(NJSelectionButtonType)i];
        NJSelectCharacterButton *button = selectionButtons[i];
        SKSpriteNode *spotLight = spotLightList[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            button.hidden = !button.hidden;
            spotLight.hidden = !spotLight.hidden;
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
    if (activePlayerList.count>0) {
        startButton.hidden = NO;
        if (!isReacted && dist<startButtonRadius) {
            [self didStartButtonClicked];
        }
    } else {
        startButton.hidden = YES;
    }
    
}

- (void)didStartButtonClicked{
    NSLog(@"game start");
    SKAction *flyAway2TopLeft = [SKAction moveByX:-700 y:700 duration:1.0];
    SKAction *flyAway2BottomLeft = [SKAction moveByX:-700 y:-700 duration:1.0];
    SKAction *flyAway2BottomRight = [SKAction moveByX:700 y:-700 duration:1.0];
    SKAction *flyAway2TopRight = [SKAction moveByX:700 y:700 duration:1.0];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
    SKAction *removeNode = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeAway, removeNode]];
    [selectionButtons[0] runAction:flyAway2TopLeft];
    [selectionButtons[1] runAction:flyAway2BottomLeft];
    [selectionButtons[2] runAction:flyAway2BottomRight];
    [selectionButtons[3] runAction:flyAway2TopRight];
    NSNotification *note = [NSNotification notificationWithName:@"activatedPlayerIndex" object:[activePlayerList copy]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    [self runAction:sequence];
}

- (CGMutablePathRef)pathOfButton:(NJSelectionButtonType)buttonType{
    CGMutablePathRef path = CGPathCreateMutable();
    switch (buttonType) {
        case BLUE:
            CGPathMoveToPoint(path, NULL, -5, 80);
            CGPathAddLineToPoint(path, NULL, -150, 170);
            CGPathAddLineToPoint(path, NULL, -80, 5);
            break;
        case PURPLE:
            CGPathMoveToPoint(path, NULL, 5, 130);
            CGPathAddLineToPoint(path, NULL, 220, 170);
            CGPathAddLineToPoint(path, NULL, 150, 5);
            break;
        case BROWN:
            CGPathMoveToPoint(path, NULL, 5, -130);
            CGPathAddLineToPoint(path, NULL, 220, -170);
            CGPathAddLineToPoint(path, NULL, 150, -5);
            break;
        case RED:
            CGPathMoveToPoint(path, NULL, -5, -80);
            CGPathAddLineToPoint(path, NULL, -160, -200);
            CGPathAddLineToPoint(path, NULL, -150, -5);
            break;
        default:
            break;
    }
    CGPathCloseSubpath(path);
    return path;
}

@end
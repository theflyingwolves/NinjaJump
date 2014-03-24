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
}

- (id) init{
    self = [super initWithImageNamed:@"ready buttons.png"];
    if (self) {
        [self addStartButton];
        [self addSelectionButtons];
        [self addSpotlight];
    }
    return self;
}

- (void)addStartButton{
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start button.png"];
    SKSpriteNode *shade = [SKSpriteNode spriteNodeWithImageNamed:@"arena shade.png"];
    [self addChild:shade];
    [self addChild:startButton];
    startButton.position = CGPointMake(30, 0);
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
    ((SKSpriteNode *)spotLightList[2]).position = CGPointMake(screenHeight/2-r, screenWidth/2-r);
    ((SKSpriteNode *)spotLightList[3]).position = CGPointMake(screenHeight/2-r, r-screenWidth/2);
    ((SKSpriteNode *)spotLightList[3]).yScale = -1;
    NSLog(@"%lu",spotLightList.count);
    for (int i=0; i<spotLightList.count; i++) {
        [self addChild:spotLightList[i]];;
    }
}

- (void)addSelectionButtons{
    NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
    NJSelectCharacterButton *selectionButtonRed = [[NJSelectCharacterButton alloc] initWithType:RED];
    NJSelectCharacterButton *selectionButtonBrown = [[NJSelectCharacterButton alloc] initWithType:BROWN];
    NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
    selectionButtons = [NSMutableArray arrayWithObjects:selectionButtonBlue, selectionButtonRed, selectionButtonPurple, selectionButtonBrown, nil];
    for (NJSelectCharacterButton *selectionButton in selectionButtons) {
        selectionButton.hidden = YES;
        selectionButton.delegate = self;
        [self addChild:selectionButton];
    }
}

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self];
//    NSLog(@"%f %f",touchPoint.x,touchPoint.y);
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<4; i++) {
        CGPathRef path= [self pathOfButton:(NJSelectionButtonType)i];
        NJSelectCharacterButton *button = selectionButtons[i];
        SKSpriteNode *spotLight = spotLightList[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            button.hidden = !button.hidden;
            spotLight.hidden = !spotLight.hidden;
        }
        CGPathRelease(path);
    }
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

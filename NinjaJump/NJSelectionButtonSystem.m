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
}

- (id) init{
    self = [super initWithImageNamed:@"ready buttons.png"];
    if (self) {
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
    return self;
}

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInNode:self];
    NSLog(@"%f %f",touchPoint.x,touchPoint.y);
    //CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<4; i++) {
        CGPathRef path= [self pathOfButton:(NJSelectionButtonType)i];
        NJSelectCharacterButton *button = selectionButtons[i];
        if (CGPathContainsPoint(path, &CGAffineTransformIdentity, touchPoint, YES)) {
            button.hidden = !button.hidden;
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

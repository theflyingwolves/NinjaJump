//
//  NJSelectCharacterButton.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectCharacterButton.h"

@implementation NJSelectCharacterButton

- (id)initWithType:(NJSelectionButtonType) buttonType{
    self = [super initWithImageNamed:[self imageNameFromType:buttonType]];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:(SKScene *)_delegate];
    NSLog(@"%f %f",touchPoint.x,touchPoint.y);
//    for (Building *building in self.buildings) {
//        if (CGPathContainsPoint(building.path, CGAffineTransformIdentity, touchPoint, YES)) {
//            //the touch was inside this building!
//            //now do something with this knowledge.
//        }
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate selectionButton:self touchesEnded:touches];
}

- (NSString *)imageNameFromType:(NJSelectionButtonType) type{
    if (type == BLUE) {
        return @"touched button blue.png";
    } else if(type == RED){
        return @"touched button red.png";
    } else if (type == BROWN){
        return @"touched button brown.png";
    } else {
        return @"touched button purple.png";
    }
}

@end

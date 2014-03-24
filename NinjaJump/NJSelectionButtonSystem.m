//
//  NJSelectionButtonSystem.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectionButtonSystem.h"

@interface NJSelectionButtonSystem()
@end

@implementation NJSelectionButtonSystem{

}


- (id) init{
    self = [super initWithImageNamed:@"ready buttons.png"];
    if (self) {
        NJSelectCharacterButton *selectionButtonBlue = [[NJSelectCharacterButton alloc] initWithType:BLUE];
        NJSelectCharacterButton *selectionButtonRed = [[NJSelectCharacterButton alloc] initWithType:RED];
        NJSelectCharacterButton *selectionButtonBrown = [[NJSelectCharacterButton alloc] initWithType:BROWN];
        NJSelectCharacterButton *selectionButtonPurple = [[NJSelectCharacterButton alloc] initWithType:PURPLE];
        NSMutableArray *selectionButtons = [NSMutableArray arrayWithObjects:selectionButtonBlue, selectionButtonRed, selectionButtonPurple, selectionButtonBrown, nil];
        for (NJSelectCharacterButton *selectionButton in selectionButtons) {
            selectionButton.hidden = YES;
            selectionButton.delegate = self;
            [self addChild:selectionButton];
        }
    }
    return self;
}


@end

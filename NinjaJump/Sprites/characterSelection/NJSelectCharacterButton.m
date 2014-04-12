//
//  NJSelectCharacterButton.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectCharacterButton.h"
#import "NJConstants.h"

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

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate button:self touchesEnded:touches];
}

- (NSString *)imageNameFromType:(NJSelectionButtonType) type{
    if(type == ORANGE){
        return kShurikenButtonOrange;
    } else if (type == BLUE) {
        return kShurikenButtonBlue;
    } else if (type == YELLOW){
        return kShurikenButtonYellow;
    } else {
        return kShurikenButtonPurple;
    }
}

@end

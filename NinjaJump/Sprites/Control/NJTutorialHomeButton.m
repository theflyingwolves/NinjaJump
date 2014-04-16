//
//  NJTutorialHomeButton.m
//  NinjaJump
//
//  Created by wulifu on 17/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTutorialHomeButton.h"

@implementation NJTutorialHomeButton

- (id)init
{
    self = [super initWithImageNamed:@"backButton.png"];
    self.size = CGSizeMake(600/7.0, 247/7.0);
    
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate homeButton:self touchesEnded:touches];
}

@end

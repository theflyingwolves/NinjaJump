//
//  NJTuTorialNextButton.m
//  NinjaJump
//
//  Created by wulifu on 13/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTuTorialNextButton.h"

@implementation NJTuTorialNextButton

- (id)init
{
    self = [super initWithColor:[UIColor grayColor] size:CGSizeMake(100, 50)];
    
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate nextButton:self touchesEnded:touches];
}

@end
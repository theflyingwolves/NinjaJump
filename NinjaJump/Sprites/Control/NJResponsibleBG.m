//
//  NJResponsibleBG.m
//  NinjaJump
//
//  Created by Wang Yichao on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJResponsibleBG.h"

@implementation NJResponsibleBG

- (id)init
{
    self = [super initWithColor:[SKColor blackColor] size:CGSizeMake(824, 568)];
    if (self) {
        self.alpha = 0;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"clickable area");
    [self.delegate backgroundTouchesEnded:(NSSet *)touches];
}

@end

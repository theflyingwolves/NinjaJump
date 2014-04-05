//
//  NJButton.m
//  NinjaJump
//
//  Created by Tang Zijian on 22/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJButton.h"

@implementation NJButton

- (id)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate button:self touchesBegan:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate button:self touchesEnded:touches];
}

@end

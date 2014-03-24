//
//  NJSelectCharacterButton.m
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSelectCharacterButton.h"

@implementation NJSelectCharacterButton

- (id)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate button:self touchesEnded:touches];
}

@end

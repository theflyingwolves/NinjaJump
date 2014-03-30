//
//  NJItemControl.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 27/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJItemControl.h"
#import "NJPlayer.h"

@implementation NJItemControl

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
    [self.delegate itemControl:self touchesEnded:touches];
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    NJSpecialItem *item = _player.item;
    if (item) {
        if (item != _itemHold) {
            [_itemHold removeFromParent];
            _itemHold = item;
            _itemHold.position = CGPointZero;
            [self addChild:_itemHold];
        }
    } else {
        [_itemHold removeFromParent];
        _itemHold = nil;
    }
}

@end

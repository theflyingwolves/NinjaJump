//
//  NJIceScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#define AFFECTED_RADIUS 100

#import "NJIceScroll.h"
#import "NJRange.h"
#import "NJCircularRange.h"

@implementation NJIceScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemIceScroll;
        self.isUsed = NO;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction{
    self.range = [[NJCircularRange alloc] initWithOrigin:self.position farDist:AFFECTED_RADIUS andFacingDir:0];
    self.isUsed = YES;
}
@end
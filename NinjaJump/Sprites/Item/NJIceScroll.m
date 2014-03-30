//
//  NJIceScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#define AFFECTED_RADIUS 250

#import "NJIceScroll.h"
#import "NJRange.h"
#import "NJCircularRange.h"
#import "NJPile.h"

@implementation NJIceScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemIceScroll;
        self.isUsed = NO;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction andWoodPiles:(NSArray *)piles byCharacter:(NJCharacter*)character
{
    self.range = [[NJCircularRange alloc] initWithOrigin:position farDist:AFFECTED_RADIUS andFacingDir:direction];
    for (NJPile *pile in piles) {
        if ([self.range isPointWithinRange:pile.position]) {
            pile.isIceScrollEnabled = YES;
        }
    }
    self.isUsed = YES;
}

@end
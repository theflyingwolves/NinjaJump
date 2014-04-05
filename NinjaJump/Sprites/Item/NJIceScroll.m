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
#import "NJScrollAnimation.h"

#define kSoundIce @"ice.mid"

@implementation NJIceScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        self.delegate = delegate;
        _itemType = NJItemIceScroll;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    self.range = [[NJCircularRange alloc] initWithOrigin:position farDist:AFFECTED_RADIUS andFacingDir:direction];
    NSArray *affectedTargets = [self.delegate getAffectedTargetsWithRange:self.range];
    for (NJCharacter *ninja in affectedTargets) {
        [ninja performFrozenEffect];
    }
    NJScrollAnimation *animation = [[NJScrollAnimation alloc] init];
    [animation runFreezeEffect:character];
    
    [self runAction:[SKAction playSoundFileNamed:kSoundIce waitForCompletion:NO]];
    
}

@end
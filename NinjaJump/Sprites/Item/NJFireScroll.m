//
//  NJFireScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJFireScroll.h"
#import "NJRange.h"
#import "NJFanRange.h"
#import "NJPile.h"
#import "NJScrollAnimation.h"

#define AFFECTED_RADIUS 350
#define kSoundFire @"fire(1).mid"

@implementation NJFireScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        self.delegate = delegate;
        _itemType = NJItemFireScroll;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    double facingDir = direction + M_PI / 2;
    NSLog(@"zrotation: %f",self.zRotation);
    self.range = [[NJFanRange alloc] initWithOrigin:character.position farDist:200 andFacingDir:facingDir];
    NSArray *affectedCharacters = [self.delegate getAffectedTargetsWithRange:self.range];
    for (NJCharacter *character in affectedCharacters) {
        [character applyDamage:20];
    }
    
    NJScrollAnimation *animation = [[NJScrollAnimation alloc] init];
    [animation runFireEffect:character];
}

@end
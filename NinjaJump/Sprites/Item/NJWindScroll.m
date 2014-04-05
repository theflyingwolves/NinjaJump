//
//  NJWindScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJWindScroll.h"
#import "NJRange.h"
#import "NJRectangularRange.h"
#import "NJPile.h"

#define AFFECTED_RADIUS 250
#define kSoundWind @"wind.mid"

@implementation NJWindScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        self.delegate = delegate;
        _itemType = NJItemWindScroll;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    double facingDir = self.zRotation;
    self.range = [[NJRectangularRange alloc] initWithOrigin:character.position farDist:70 andFacingDir:facingDir];
    NSArray *affectedCharacters = [self.delegate getAffectedTargetsWithRange:self.range];
    for (NJCharacter *character in affectedCharacters) {
        [character applyDamage:20];
    }
    
    //[self runAction:[SKAction playSoundFileNamed:kSoundWind waitForCompletion:NO]];
}

@end

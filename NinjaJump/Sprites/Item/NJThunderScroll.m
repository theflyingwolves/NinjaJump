//
//  NJThunderScroll.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJThunderScroll.h"
#import "NJCircularRange.h"
#import "NJPile.h"
#import "NJConstants.h"

#define AFFECTED_RADIUS 200
#define kSoundThunder @"thunder.mid"

@implementation NJThunderScroll

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
        _itemType = NJItemThunderScroll;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    self.range = [[NJCircularRange alloc] initWithOrigin:position farDist:AFFECTED_RADIUS andFacingDir:direction];
    NSArray *affectedCharacters = [self.delegate getAffectedTargetsWithRange:self.range];
    for (NJCharacter *character in affectedCharacters) {
        [character applyMagicalDamage:kThunderScrollDamage];
        [self fireAttackedAnimation:character];
    }
    [character performThunderAnimation];
    [self runAction:[SKAction playSoundFileNamed:kSoundThunder waitForCompletion:NO]];
}
@end
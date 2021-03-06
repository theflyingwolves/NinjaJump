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
#import "NJConstants.h"

#define AFFECTED_RADIUS 350
#define kSoundFire @"firestrong.mid"

@implementation NJFireScroll

static ProductId *pId = kFireScrollProductId;

+ (instancetype)itemAtPosition:(CGPoint)position delegate:(id<NJScrollDelegate>)delegate
{
    return [[NJFireScroll alloc] initWithTextureNamed:kFireScrollFileName atPosition:position delegate:delegate];
}

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
    double facingDir = direction;
    self.range = [[NJFanRange alloc] initWithOrigin:character.position farDist:AFFECTED_RADIUS andFacingDir:facingDir];
    NSArray *affectedCharacters = [self.delegate getAffectedTargetsWithRange:self.range];
    for (NJCharacter *character in affectedCharacters) {
        [character applyMagicalDamage:kFireScrollDamage];
        [self fireAttackedAnimation:character];
    }
    NSArray *affectedPiles = [self.delegate getAffectedPilesWithRange:self.range];
    for (NJPile *pile in affectedPiles) {
        pile.isOnFire = YES;
        pile.fireTimer = 0;
    }
    
    NJScrollAnimation *animation = [[NJScrollAnimation alloc] init];
    [animation runFireEffect:character];
    
    [self runAction:[SKAction playSoundFileNamed:kSoundFire waitForCompletion:NO]];
}

- (ProductId *)getProductId
{
    return kFireScrollProductId;
}

@end
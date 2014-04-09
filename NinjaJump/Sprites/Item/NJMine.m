//
//  NJMine.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJMine.h"
#import "NJEffectMine.h"


@implementation NJMine

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position{
    self = [super initWithTextureNamed:textureName atPosition:position];
    if (self){
//        _itemType = NJItemMine;
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"FireworkRed" ofType:@"sks"];
        SKEmitterNode *fireworkRed = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath2];
        fireworkRed.position = CGPointMake(15, 15);
        [fireworkRed setScale:0.2];
        fireworkRed.zRotation = self.zRotation;
        [self addChild:fireworkRed];
    }
    
    return self;
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter*)character
{
    NJEffectMine *mine = [[NJEffectMine alloc] initAtPosition:position withDirection:direction onScene:self.myParent andOwner:character];
    [mine performEffect];
}

@end

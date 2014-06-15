//
//  NJSpecialItem.m
//  NinjaJump
//
//  Created by wulifu on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJSpecialItem.h"
#import "NJConstants.h"

@implementation NJSpecialItem

+(instancetype)itemAtPosition:(CGPoint)position
{
    //Overridden by Subclasses
    return nil;
}

-(instancetype)initWithTextureNamed:(NSString *)textureName atPosition:(CGPoint)position
{
    self = [super initWithImageNamed:textureName];
    if (self){
        self.position = position;
        self.isPickedUp = NO;
        _lifeTime = 0;
        _itemShadow = [[SKSpriteNode alloc] initWithImageNamed:itemShadowImageName];
    }
    
    return self;
}

// EFFECTS: Update the next-frame state of the item on the screen
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval{
    _lifeTime += interval; //increase the lifetime until hit the max, item will disappear
}

- (void)useAtPosition:(CGPoint)position withDirection:(CGFloat)direction byCharacter:(NJCharacter *)character
{
    //Overridden by Subclasses
    //NSLog(@"use item!");
}

- (ProductId *)getProductId
{
    // Overridden by subclasses
    return nil;
}

@end
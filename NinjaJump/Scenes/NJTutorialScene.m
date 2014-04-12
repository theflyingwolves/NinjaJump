//
//  NJTutorialScene.m
//  NinjaJump
//
//  Created by wulifu on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJTutorialScene.h"
#import "NJPlayer.h"
#import "NJPile.h"
#import "NJGraphicsUnitilities.h"
#import "NJShuriken.h"
#import "NJMedikit.h"
#import "NJIceScroll.h"
#import "NJConstants.h"
#import "NJScroll.h"

#define kItemNameShuriken 0
#define kItemNameMedikit 1
#define kItemNameIceScroll 2

@interface NJTutorialScene ()  <NJScrollDelegate>

@end


@implementation NJTutorialScene

- (instancetype)initWithSizeWithoutSelection:(CGSize)size{
    self = [super initWithSizeWithoutSelection:size];
    if (self){
        ((NJPlayer*)self.players[0]).isDisabled = NO;
        ((NJPlayer*)self.players[1]).isDisabled = NO;
        ((NJPlayer*)self.players[2]).isDisabled = YES;
        ((NJPlayer*)self.players[3]).isDisabled = YES;
        [self activateSelectedPlayersWithPreSetting];
        
        [self.itemControls[1] removeFromParent];
        [self.buttons[1] removeFromParent];
        
        self.doAddItemRandomly = NO;
//        [self addItem:0];
//        [self addItem:1];
//        [self addItem:2];
    }
    
    return  self;
}

- (void)addItem:(NSInteger)itemName{
    NJPile *pile = [self spawnAtRandomPileForNinja:NO];
    if (!pile) {
        return;
    }
    CGPoint position = pile.position;
    
    NJSpecialItem *item;
    
    switch (itemName) {
        case kItemNameIceScroll:
        item = [[NJIceScroll alloc] initWithTextureNamed:kIceScrollFileName atPosition:position delegate:self];
        break;
        
        case kItemNameMedikit:
        item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
        break;
        
        case kItemNameShuriken:
        item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
        break;
        
        default:
        break;
    }
    
    if (item != nil) {
        item.myParent = self;
        pile.itemHolded = item;
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [self.items addObject:item];
    }

}


#pragma overriden method
- (void)addWoodPiles
{
    CGFloat r= 120.0f;
    NSArray *pilePos = [NSArray arrayWithObjects: [NSValue valueWithCGPoint:CGPointMake(r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, r)], [NSValue valueWithCGPoint:CGPointMake(1024-r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(r, 768-r)], [NSValue valueWithCGPoint:CGPointMake(512, 580)], [NSValue valueWithCGPoint:CGPointMake(250, 250)], [NSValue valueWithCGPoint:CGPointMake(350, 100)], [NSValue valueWithCGPoint:CGPointMake(650, 350)], [NSValue valueWithCGPoint:CGPointMake(850, 400)], [NSValue valueWithCGPoint:CGPointMake(100, 300)], [NSValue valueWithCGPoint:CGPointMake(250, 500)], [NSValue valueWithCGPoint:CGPointMake(550, 400)], [NSValue valueWithCGPoint:CGPointMake(700, 600)], [NSValue valueWithCGPoint:CGPointMake(750, 150)], nil];
    //add in the spawn pile of ninjas
    for (NSValue *posValue in pilePos){
        CGPoint pos = [posValue CGPointValue];
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:pos withSpeed:0 angularSpeed:3 direction:arc4random()%2];
        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
        CGFloat ang = NJRandomAngle();
    }
}




@end

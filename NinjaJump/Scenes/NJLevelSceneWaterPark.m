//
//  NJLevelSceneWaterPark.m
//  NinjaJump
//
//  Created by Zijian on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJLevelSceneWaterPark.h"
#import "NJNinjaCharacter.h"
#import "NJPile.h"
#import "NJPath.h"

#define kBackGroundFileName @"waterParkBG.jpg"

@interface NJLevelSceneWaterPark () <SKPhysicsContactDelegate>
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic) NSMutableArray *woodPiles;              // all the wood piles in the scene
@end
@implementation NJLevelSceneWaterPark
@synthesize ninjas = _ninjas;
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _ninjas = [[NSMutableArray alloc] init];
        _woodPiles = [[NSMutableArray alloc] init];
        [self buildWorld];
    }
    return self;
}
#pragma mark - World Building
- (void)buildWorld {
    NSLog(@"Building the world");
    
    // Configure physics for the world.
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f); // no gravity
    self.physicsWorld.contactDelegate = self;
    
    [self addBackground];
    
    [self addWoodPiles];
    
//    [self addSpawnPoints];
}

- (void)addWoodPiles
{
    CGPoint center = CGPointMake(CGRectGetHeight(self.frame)/2,CGRectGetWidth(self.frame)/2);
    NSValue *centerValue = [NSValue valueWithCGPoint:center];
    NSValue *test1 = [NSValue valueWithCGPoint:CGPointMake(center.x + 100, center.y  + 100)];
    NSValue *test2 = [NSValue valueWithCGPoint:CGPointMake(center.x + 100, center.y  - 100)];
    NSNumber *mode = [NSNumber numberWithInteger:linear];
    
    NJPath *path1 = [[NJPath alloc] initPathWithPoints:@[centerValue, test1, test2] andMode:@[mode, mode]];
    NJPile *pile1 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:center withSpeed:150 angularSpeed:5 path:path1];
    
    [self addNode:pile1 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile1];
    
    NSValue *test3 = [NSValue valueWithCGPoint:CGPointMake(center.x + 200, center.y  + 200)];
    NSValue *test4 = [NSValue valueWithCGPoint:CGPointMake(center.x + 200, center.y  - 200)];
    NSValue *test5 = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y  - 200)];
    
    NJPath *path2 = [[NJPath alloc] initPathWithPoints:@[test3, test4, test5] andMode:@[mode, mode]];
    NJPile *pile2 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:test3.CGPointValue withSpeed:150 angularSpeed:5 path:path2];
    
    [self addNode:pile2 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile2];
}


- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:kBackGroundFileName];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
}

/*
#pragma mark - Level Start
- (void)startLevel {
    for (NJPlayer *player in self.players) {
        NJNinjaCharacter *ninja = [self addHeroForPlayer:player];
    }
}
*/
#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    /*
    // Update all players' ninjas.
    for (NJNinjaCharacter *ninja in self.ninjas) {
        [ninja updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    */
    for (NJPile *pile in _woodPiles) {
        [pile updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}


#pragma mark - Shared Assets
+ (void)loadSceneAssets
{
    
}

@end

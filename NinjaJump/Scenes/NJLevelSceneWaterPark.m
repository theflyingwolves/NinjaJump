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
    for (int i=0; i<5; i++) {
        double rand1 = ((arc4random()%80)/100.0)+0.1;
        double rand2 = ((arc4random()%80)/100.0)+0.1;
        NSLog(@"%f",rand1);
        NSLog(@"%f",rand2);
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(rand1*CGRectGetHeight(self.frame),rand2*CGRectGetWidth(self.frame)) withSpeed:0 angularSpeed:5 path:nil];

        [self addNode:pile atWorldLayer:NJWorldLayerBelowCharacter];
        [self.woodPiles addObject:pile];
    }
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

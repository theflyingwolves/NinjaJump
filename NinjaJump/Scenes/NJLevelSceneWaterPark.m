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
#import "NJButton.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"

#define kBackGroundFileName @"waterParkBG.jpg"

@interface NJLevelSceneWaterPark () <SKPhysicsContactDelegate, NJButtonDelegate>
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic) NSMutableArray *woodPiles;              // all the wood piles in the scene
@property (nonatomic) NSMutableArray *buttons;
@end
@implementation NJLevelSceneWaterPark
@synthesize ninjas = _ninjas;
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _ninjas = [[NSMutableArray alloc] init];
        _woodPiles = [[NSMutableArray alloc] init];
        _buttons = [NSMutableArray arrayWithCapacity:kNumPlayers];
        for (int i = 0; i < kNumPlayers; i++) {
            NJButton *button = [[NJButton alloc] initWithImageNamed:@"jumpButton"];
            button.delegate = self;
            button.player = self.players[i];
            [_buttons addObject:button];
            [self addChild:button];
        }
        ((SKSpriteNode*)_buttons[0]).position = CGPointMake(50, 50);
        ((SKSpriteNode*)_buttons[0]).zRotation = -M_PI/4;
        ((SKSpriteNode*)_buttons[1]).position = CGPointMake(974, 50);
        ((SKSpriteNode*)_buttons[1]).zRotation = M_PI/4;
        ((SKSpriteNode*)_buttons[2]).position = CGPointMake(50, 718);
        ((SKSpriteNode*)_buttons[2]).zRotation = -M_PI/4*3;
        ((SKSpriteNode*)_buttons[3]).position = CGPointMake(974, 718);
        ((SKSpriteNode*)_buttons[3]).zRotation = M_PI/4*3;
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
}

- (void)addWoodPiles
{
    for (int i=0; i < 5; i++) {
        float rand1 = (arc4random()%60)/100.0+0.2;
        float rand2 = (arc4random()%60)/100.0+0.2;
        NJPile *pile = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(rand1*CGRectGetWidth(self.frame), rand2*CGRectGetHeight(self.frame)) withSpeed:0 angularSpeed:5 path:nil];
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


#pragma mark - Level Start
- (void)startLevel {
    for (NJPlayer *player in self.players) {
        NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
        int index = arc4random() % [_woodPiles count];
        ninja.position = ((NJPile*)_woodPiles[index]).position;
    }
}

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
        for (NJNinjaCharacter *ninja in _ninjas) {
            if (CGPointEqualToPoint(ninja.position, pile.position)) {
                ninja.zRotation += pile.angleRotatedSinceLastUpdate;
                while (ninja.zRotation>=2*M_PI) {
                    ninja.zRotation -= 2*M_PI;
                }
            }
        }
    }
}

#pragma mark - Event Handling

- (void)button:(NJButton *)button touchesEnded:(NSSet *)touches {
    NSArray *ninjas = self.ninjas;
    if ([ninjas count] < 1) {
        return;
    }
    NJPile *pile = [self woodPileToJump:button.player.ninja];
    if (pile && !button.player.isJumping) {
        button.player.targetLocation = pile.position;
        button.player.jumpRequested = YES;
        button.player.isJumping = YES;
    }
}

- (NJPile *)woodPileToJump:(NJNinjaCharacter *)ninja
{
    for (NJPile *pile in _woodPiles) {
        if (!CGPointEqualToPoint(pile.position, ninja.position)) {
            /*
            CGFloat ang = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(pile.position, ninja.position));
            NSLog(@"angle: %f",ang);
            NSLog(@"zRotate: %f",ninja.zRotation);
            float dx = pile.position.x - ninja.position.x;
            float dy = pile.position.y - ninja.position.y;
            if (fabs(ang-ninja.zRotation)<=(2*asinf(pile.size.width/hypotf(dx, dy)))) {
                return pile;
            }
             */
            float dx = pile.position.x - ninja.position.x;
            float dy = pile.position.y - ninja.position.y;
            float zRotation = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(pile.position, ninja.position));
            
            float dxabs = fabs(dx);
            float dyabs = fabs(dy);
            float dist = hypotf(dxabs, dyabs);
            float radius = pile.size.width / 2;
            float angleSpaned = atan2f(radius,dist);
            while (ninja.zRotation>=2*M_PI) {
                ninja.zRotation -= 2*M_PI;
            }
            if (zRotation-2*angleSpaned <= ninja.zRotation && zRotation+2*angleSpaned >= ninja.zRotation) {
                return pile;
            }
            
//            NSLog(@"angle spanned %f",angleSpaned);
//            NSLog(@"%f",angle - ninja.zRotation);
            
            
//            if (fabs(angle-ninja.zRotation+M_PI/2)<=(2*asin(hypotf(pile.size.width, pile.size.height)/2/hypotf(dx, dy)))) {
//                return pile;
//            }
        }
    }
    return nil;
}

#pragma mark - Shared Assets
+ (void)loadSceneAssets
{
    
}

@end

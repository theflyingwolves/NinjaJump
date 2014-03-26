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
#import "NJHPBar.h"
#import "NJPlayer.h"
#import "NJGraphicsUnitilities.h"
#import "NJNinjaCharacterNormal.h"
#import "NJSelectionButtonSystem.h"

#import "NJThunderScroll.h"
#import "NJWindScroll.h"
#import "NJIceScroll.h"
#import "NJFireScroll.h"
#import "NJMine.h"
#import "NJShuriken.h"
#import "NJMedikit.h"

#define kBackGroundFileName @"waterParkBG.png"
#define kThunderScrollFileName @"thunderScroll.png"
#define kWindScrollFileName @"windScroll.png"
#define kIceScrollFileName @"iceScroll.png"
#define kFireScrollFileName @"fireScroll.png"
//#define kMineFileName @"mine.png"
#define kShurikenFileName @"shuriken.png"
#define kMedikitFileName @"medikit.png"

#define kNumOfFramesToSpawnItem 1000;

@interface NJLevelSceneWaterPark () <SKPhysicsContactDelegate, NJButtonDelegate>
@property (nonatomic, readwrite) NSMutableArray *ninjas;
@property (nonatomic, readwrite) NSMutableArray *woodPiles;// all the wood piles in the scene
@property (nonatomic ,readwrite) NSMutableArray *items;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSMutableArray *hpBars;
@end

@implementation NJLevelSceneWaterPark
@synthesize ninjas = _ninjas;
@synthesize woodPiles = _woodPiles;
@synthesize items = _items;
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        _ninjas = [[NSMutableArray alloc] init];
        _items = [[NSMutableArray alloc] init];
        _woodPiles = [[NSMutableArray alloc] init];
        _buttons = [NSMutableArray arrayWithCapacity:kNumPlayers];
        _hpBars = [NSMutableArray arrayWithCapacity:kNumPlayers];
        
        for (int i=0; i < kNumPlayers; i++) {
            CGPoint position;
            float size = 250;
            switch (i) {
                case 0:
                    position = CGPointMake(size / 2, size / 2);
                    break;
                case 1:
                    position = CGPointMake(self.frame.size.width - size / 2, size / 2);
                    break;
                case 2:
                    position = CGPointMake(self.frame.size.width - size / 2, self.frame.size.height - size / 2);
                    break;
                case 3:
                    position = CGPointMake(size / 2, self.frame.size.height - size / 2);
                    break;
                default:
                    break;
            }
                        
            NJHPBar *bar = [NJHPBar hpBarWithPosition:position andPlayer:self.players[i]];
            float angle = i * M_PI / 2 - M_PI / 2;
            bar.zRotation = angle;
            [_hpBars addObject:bar];
            [self addChild:bar];
        }

        for (int i = 0; i < kNumPlayers; i++) {
            NJButton *button = [[NJButton alloc] initWithImageNamed:@"jumpButton"];
            button.delegate = self;
            button.player = self.players[i];
            [_buttons addObject:button];
            [self addChild:button];
        }
        
        ((NJButton*)_buttons[0]).position = CGPointMake(50, 50);
        ((NJButton*)_buttons[0]).zRotation = -M_PI/4;
        ((NJButton*)_buttons[0]).color = [SKColor blackColor];
        ((NJButton*)_buttons[0]).colorBlendFactor = 1.0;
        ((NJButton*)_buttons[0]).player.color = [SKColor blackColor];
        ((NJButton*)_buttons[1]).position = CGPointMake(974, 50);
        ((NJButton*)_buttons[1]).zRotation = M_PI/4;
        ((NJButton*)_buttons[1]).color = [SKColor blueColor];
        ((NJButton*)_buttons[1]).colorBlendFactor = 1.0;
        ((NJButton*)_buttons[1]).player.color = [SKColor blueColor];
        ((NJButton*)_buttons[2]).position = CGPointMake(974, 718);
        ((NJButton*)_buttons[2]).zRotation = -M_PI/4*3;
        ((NJButton*)_buttons[2]).color = [SKColor yellowColor];
        ((NJButton*)_buttons[2]).colorBlendFactor = 1.0;
        ((NJButton*)_buttons[2]).player.color = [SKColor yellowColor];
        ((NJButton*)_buttons[3]).position = CGPointMake(50, 718);
        ((NJButton*)_buttons[3]).zRotation = M_PI/4*3;
        ((NJButton*)_buttons[3]).color = [SKColor redColor];
        ((NJButton*)_buttons[3]).colorBlendFactor = 1.0;
        ((NJButton*)_buttons[3]).player.color = [SKColor redColor];
        [self initSelectionSystem];
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

- (void)addItem{
    CGPoint position = [self spawnAtRandomPosition];
    
    if ([self.items count] < 3) {
        int index = arc4random() % NJItemCount;
        NJSpecialItem *item;
        
        switch (index) {
            case NJItemThunderScroll:
                item = [[NJThunderScroll alloc] initWithTextureNamed:kThunderScrollFileName atPosition:position];
                break;
                
            case NJItemWindScroll:
                item = [[NJWindScroll alloc] initWithTextureNamed:kWindScrollFileName atPosition:position];
                break;
                
            case NJItemIceScroll:
                item = [[NJIceScroll alloc] initWithTextureNamed:kIceScrollFileName atPosition:position];
                break;
                
            case NJItemFireScroll:
                item = [[NJFireScroll alloc] initWithTextureNamed:kFireScrollFileName atPosition:position];
                break;
                
            case NJItemMedikit:
                item = [[NJMedikit alloc] initWithTextureNamed:kMedikitFileName atPosition:position];
                break;
                
                //        case NJItemMine:
                //            item = [[NJMine alloc] initWithTextureNamed:kMineFileName atPosition:position];
                //            break;
                
            case NJItemShuriken:
                item = [[NJShuriken alloc] initWithTextureNamed:kShurikenFileName atPosition:position];
                break;
                
            default:
                break;
        }
        
        [self addNode:item atWorldLayer:NJWorldLayerCharacter];
        [_items addObject:item];
    }
}

- (BOOL)hasItemOnPosition:(CGPoint)position{
    for (NJSpecialItem *item in self.items){
        if (CGPointEqualToPoint(position, item.position)) {
            return YES;
        }
    }
    return NO;
}

- (void)addWoodPiles
{
    //add in the spawn pile of ninjas
    CGFloat r= 120.0f;
    NJPile *pile11 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(r, r) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile11 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile11];
    NJPile *pile12 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(1024-r, r) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile12 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile12];
    NJPile *pile13 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(1024-r, 768-r) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile13 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile13];
    NJPile *pile14 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(r, 768-r) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile14 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile14];
    
    //hard coded 10 piles for now
    NJPile *pile1 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(512, 580) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile1 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile1];
    NJPile *pile2 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(250, 250) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile2 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile2];
    NJPile *pile3 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(350, 100) withSpeed:0 angularSpeed:3 direction:NJDirectionCounterClockwise path:nil];
    [self addNode:pile3 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile3];
    NJPile *pile4 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(650, 350) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile4 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile4];
    NJPile *pile5 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(850, 400) withSpeed:0 angularSpeed:3 direction:NJDirectionCounterClockwise path:nil];
    [self addNode:pile5 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile5];
    NJPile *pile6 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(100, 300) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile6 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile6];
    NJPile *pile7 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(250, 500) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile7 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile7];
    NJPile *pile8 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(550, 400) withSpeed:0 angularSpeed:3 direction:NJDirectionCounterClockwise path:nil];
    [self addNode:pile8 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile8];
    NJPile *pile9 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(700, 600) withSpeed:0 angularSpeed:3 direction:NJDiectionClockwise path:nil];
    [self addNode:pile9 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile9];
    NJPile *pile10 = [[NJPile alloc] initWithTextureNamed:@"woodPile" atPosition:CGPointMake(750, 150) withSpeed:0 angularSpeed:3 direction:NJDirectionCounterClockwise path:nil];
    [self addNode:pile10 atWorldLayer:NJWorldLayerBelowCharacter];
    [self.woodPiles addObject:pile10];
}


- (void)addBackground
{
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:kBackGroundFileName];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addNode:background atWorldLayer:NJWorldLayerGround];
}

#pragma mark - Level Start
- (void)startLevel {
    for (int index=0; index<4; index++) {
        NJPlayer *player = self.players[index];
        NJNinjaCharacter *ninja = [self addNinjaForPlayer:player];
        CGPoint spawnPosition = ((NJPile*)_woodPiles[index]).position;
        ninja.position = spawnPosition;
        [ninja setSpawnPoint:spawnPosition];
    }
}

#pragma mark - Loop Update
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast
{
    // Update all players' ninjas.
    for (NJNinjaCharacter *ninja in self.ninjas) {
        [ninja updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    for (NJPile *pile in _woodPiles) {
        [pile updateWithTimeSinceLastUpdate:timeSinceLast];
        for (NJNinjaCharacter *ninja in _ninjas) {
            if (CGPointEqualToPoint(ninja.position, pile.position)) {
                ninja.zRotation += pile.angleRotatedSinceLastUpdate;
                if (pile.rotateDirection == NJDirectionCounterClockwise) {
                    while (ninja.zRotation>=2*M_PI) {
                        ninja.zRotation -= 2*M_PI;
                    }
                } else {
                    while (ninja.zRotation<0) {
                        ninja.zRotation += 2*M_PI;
                    }
                }
            }
        }
    }
    
    for (NJHPBar *bar in _hpBars) {
        [bar updateHealthPoint];
    }
    
    int toSpawnItem = arc4random() % kNumOfFramesToSpawnItem;
    if (toSpawnItem==1) {
        [self addItem];
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
        button.player.startLocation = button.player.ninja.position;
        button.player.targetLocation = pile.position;
        button.player.jumpRequested = YES;
        button.player.isJumping = YES;
    }
}

- (NJPile *)woodPileToJump:(NJNinjaCharacter *)ninja
{
    NJPile *nearest = nil;
    for (NJPile *pile in _woodPiles) {
        if (!CGPointEqualToPoint(pile.position, ninja.position)) {
            float dx = pile.position.x - ninja.position.x;
            float dy = pile.position.y - ninja.position.y;
            float zRotation = NJ_POLAR_ADJUST(NJRadiansBetweenPoints(pile.position, ninja.position));
            
            if (zRotation < 0 && zRotation >= -M_PI/2) {
                zRotation += 2*M_PI;
            }
            float dist = hypotf(dx, dy);
            float radius = pile.size.width / 2;
            float angleSpaned = atan2f(radius,dist);
            if (zRotation-3*angleSpaned <= ninja.zRotation && zRotation+3*angleSpaned >= ninja.zRotation) {
                if (nearest == nil) {
                    nearest = pile;
                } else if (NJDistanceBetweenPoints(ninja.position, nearest.position)>NJDistanceBetweenPoints(ninja.position, pile.position)) {
                    nearest = pile;
                }
            }
        }
    }
    return nearest;
}

- (CGPoint)spawnAtRandomPosition
{
    NSMutableArray *array = [NSMutableArray new];
    for (NJPile *pile in _woodPiles) {
        BOOL isFree = YES;
        for (NJPlayer *player in self.players) {
            if (CGPointEqualToPoint(pile.position, player.ninja.position) || (CGPointEqualToPoint(pile.position, player.targetLocation))) {
                isFree = NO;
            }
        }
        for (NJSpecialItem *item in self.items){
            if (CGPointEqualToPoint(pile.position, item.position)) {
                isFree = NO;
            }
        }
        if (isFree) {
            [array addObject:pile];
        }
    }
    int index = arc4random() % [array count];
    CGPoint spawnPosition = ((NJPile*)array[index]).position;
    return spawnPosition;
}

#pragma mark - Shared Assets
+ (void)loadSceneAssets
{
    [NJNinjaCharacterNormal loadSharedAssets];
}

/**********Select Player Scene*************/
- (void)initSelectionSystem{
    NJSelectionButtonSystem *selectionSystem = [[NJSelectionButtonSystem alloc]init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = CGPointMake(screenHeight/2, screenWidth/2);
    selectionSystem.position = center;
    [self addChild:selectionSystem];
}

@end

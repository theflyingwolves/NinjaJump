//
//  NJViewController.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJViewController.h"
#import "NJLoadingScene.h"
#import "NJMultiplayerLayeredCharacterScene.h"
#import <SpriteKit/SpriteKit.h>

@interface NJViewController ()
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) NJMultiplayerLayeredCharacterScene *scene;
@end

@implementation NJViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Configure the view.
    _skView.showsFPS = YES;
    _skView.showsDrawCount = YES;
    _skView.showsNodeCount = YES;
    
    NJLoadingScene *loadingScene = [[NJLoadingScene alloc] initWithSize:_skView.bounds.size];
    loadingScene.scaleMode = SKSceneScaleModeAspectFill;
    [_skView presentScene:loadingScene];
    [NJMultiplayerLayeredCharacterScene loadSceneAssetsWithCompletionHandler:^{
        NSLog(@"loading assets completed.");
        // Create and configure the scene.
        NJMultiplayerLayeredCharacterScene * scene = [NJMultiplayerLayeredCharacterScene sceneWithSize:_skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        self.scene = scene;
        // Present the scene.
        [_skView presentScene:scene];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

//
//  NJViewController.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 15/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJViewController.h"
#import "NJStoreViewController.h"
#import "NJLoadingScene.h"
#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJTutorialScene.h"
#import "NJMainScene.h"
#import "NJModeSelectionScene.h"
#import <SpriteKit/SpriteKit.h>

@interface NJViewController () <NJMainSceneDelegate,NJModeSelectionSceneDelegate,NJMultiplayerLayeredCharacterSceneDelegate>
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) NJMultiplayerLayeredCharacterScene *scene;
@property (nonatomic) NJStore *store;
@end

@implementation NJViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    // Configure the view.
    NJLoadingScene *loadingScene = [[NJLoadingScene alloc] initWithSize:_skView.bounds.size];
    loadingScene.scaleMode = SKSceneScaleModeAspectFill;
    [_skView presentScene:loadingScene];
    NJMainScene *mainScene = [[NJMainScene alloc] initWithSize:_skView.bounds.size];
    mainScene.delegate = self;
    mainScene.scaleMode = SKSceneScaleModeAspectFill;
    [_skView presentScene:mainScene];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _store = [NJStore store];
}

- (void)modeSelected:(NJGameMode)mode
{
    if (mode == NJGameModeCount) {
        [self performSegueWithIdentifier:@"store" sender:self];
    }else{
    [NJMultiplayerLayeredCharacterScene loadSceneAssetsWithCompletionHandler:^{
        if (mode == NJGameModeTutorial) {
            // Initialize Tutorial Scene Here
            NJTutorialScene *scene = [[NJTutorialScene alloc] initWithSizeWithoutSelection:_skView.bounds.size store:_store];
            self.scene = scene;
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.delegate = self;
            [_skView presentScene:scene transition:[SKTransition crossFadeWithDuration:0.5f]];
        }else{
            // Create and configure the scene.
            NJMultiplayerLayeredCharacterScene * scene = [[NJMultiplayerLayeredCharacterScene alloc] initWithSize:_skView.bounds.size mode:mode store:_store];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.delegate = self;
            self.scene = scene;
            // Present the scene.
            [_skView presentScene:scene transition:[SKTransition crossFadeWithDuration:0.5f]];
        }
    }];
    }
}

- (void)mainModeSelected:(NJGameMode)mode
{
    if (mode == NJGameModeCount) {
        [self performSegueWithIdentifier:@"store" sender:self];
    }else{
        NJModeSelectionScene *modeSelectionScene = [[NJModeSelectionScene alloc] initWithSize:_skView.bounds.size];
        modeSelectionScene.scaleMode = SKSceneScaleModeAspectFill;
        modeSelectionScene.delegate = self;
        [_skView presentScene:modeSelectionScene];
    }
}

- (void)backToModeSelectionScene
{
    NJModeSelectionScene *modeSelectionScene = [[NJModeSelectionScene alloc] initWithSize:_skView.bounds.size];
    modeSelectionScene.scaleMode = SKSceneScaleModeAspectFill;
    modeSelectionScene.delegate = self;
    [_skView presentScene:modeSelectionScene];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *dest = segue.destinationViewController;
    if ([dest isKindOfClass:[NJStoreViewController class]]) {
        NJStoreViewController *storeViewController = (NJStoreViewController *)dest;
        [storeViewController setStoreForView:_store];
    }
}
@end

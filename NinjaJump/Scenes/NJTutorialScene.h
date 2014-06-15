//
//  NJTutorialScene.h
//  NinjaJump
//
//  Created by wulifu on 12/4/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

/*
    This class is the scene used by the tutorial mode
*/

#import "NJMultiplayerLayeredCharacterScene.h"
#import "NJTuTorialNextButton.h"
#import "NJTutorialHomeButton.h"

@interface NJTutorialScene : NJMultiplayerLayeredCharacterScene <NJTuTorialNextButtonDelegate, NJTuTorialHomeButtonDelegate>

@property (nonatomic) NJTuTorialNextButton *nextButton; //the next button in the dialog
@property (nonatomic) NJTutorialHomeButton *homeButton; //button to go back to home scene

- (instancetype)initWithSizeWithoutSelection:(CGSize)size store:(NJStore *)store;
//REQUIRES: size to be a valid size (e.g. screen size)
//MODIFIES: self
//RETURNS: returns a instance of this class



@end

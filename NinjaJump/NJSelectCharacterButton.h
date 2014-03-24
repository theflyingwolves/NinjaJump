//
//  NJSelectCharacterButton.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef enum {BLUE, RED, PURPLE, BROWN} NJSelectionButtonType ;

@class NJSelectCharacterButton;
@protocol NJSelectionButtonDelegate <NSObject>

- (void)selectionButton:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches;

@end

@interface NJSelectCharacterButton : SKSpriteNode

@property (nonatomic, weak) id <NJSelectionButtonDelegate> delegate;

- (id)initWithType:(NJSelectionButtonType) buttonType;
@end

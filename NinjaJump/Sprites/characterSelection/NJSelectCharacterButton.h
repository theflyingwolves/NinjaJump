//
//  NJSelectCharacterButton.h
//  NinjaJump
//
//  Created by Wang Yichao on 24/3/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef enum {ORANGE=0, BLUE=1, YELLOW=2, PURPLE=3} NJSelectionButtonType ;

@class NJSelectCharacterButton;
@protocol NJSelectionButtonDelegate <NSObject>

- (void)button:(NJSelectCharacterButton *) button touchesEnded:(NSSet *)touches;

@end

@interface NJSelectCharacterButton : SKSpriteNode

@property (nonatomic, weak) id <NJSelectionButtonDelegate> delegate;

- (id)initWithType:(NJSelectionButtonType) buttonType;
@end

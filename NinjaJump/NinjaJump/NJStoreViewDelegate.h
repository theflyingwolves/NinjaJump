//
//  NJStoreViewDelegate.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 26/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NJStoreViewDelegate <NSObject>
- (BOOL)buyProductWithId:(ProductId *)pId;
@end
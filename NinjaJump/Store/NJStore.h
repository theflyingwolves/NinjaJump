//
//  NJStore.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJProductId.h"
#import "NJStoreViewDelegate.h"

@interface NJStore : NSObject <NJStoreViewDelegate>
+ (NJStore *)store;
- (BOOL)isProductUnlocked:(ProductId *)pId;
- (NSArray *)buyableItemImageNames;
@end
//
//  NJStoreView.h
//  NinjaJump
//
//  Created by Wang Kunzhen on 25/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJStore.h"

@interface NJStoreViewController: UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)setStore:(NJStore *)store;

@end

//
//  NJStore.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJStore.h"

@interface NJStore ()
@property NJStore *store;
@property NSUInteger account;
@property NSDictionary *playerInfo;
@property NSDictionary *productInfo;
@end

@implementation NJStore

+ (NJStore *)store
{
    return [[NJStore alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        _playerInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayerInfo" ofType:@"plist"]];
        _productInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProductInfo" ofType:@"plist"]];
    }
    return self;
}

- (BOOL)isProductUnlocked:(NSString *)pId
{
    NSDictionary *product = [_productInfo objectForKey:pId];
    BOOL isUnlocked = [product objectForKey:@"isUnlocked"];
    if (isUnlocked) {
        NSLog(@"Product %@ is unlocked",pId);
    }else{
        NSLog(@"Product %@ is locked",pId);
    }
    
    return isUnlocked;
}

- (NSArray *)buyableItemImageNames
{
    return nil;
}

- (BOOL)buyProductWithId:(NSString *)pId
{
    return YES;
}

- (void)backupStore
{
    NSString *error;
    NSData *playerInfoData = [NSPropertyListSerialization dataFromPropertyList:_playerInfo
                                                                        format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if (playerInfoData) {
        [playerInfoData writeToFile:[[NSBundle mainBundle] pathForResource:@"PlayerInfo" ofType:@"plist"] atomically:YES];
        NSLog(@"The path is %@",[[NSBundle mainBundle] pathForResource:@"PlayerInfo" ofType:@"plist"]);
    }else{
        NSLog(@"Error backing up player information: %@",error);
    }
    
    NSData *productInfoData = [NSPropertyListSerialization dataFromPropertyList:_productInfo
                                                                        format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if (productInfoData) {
        [productInfoData writeToFile:[[NSBundle mainBundle] pathForResource:@"ProductInfo" ofType:@"plist"] atomically:YES];
    }else{
        NSLog(@"Error backing up product information: %@",error);
    }
}
@end
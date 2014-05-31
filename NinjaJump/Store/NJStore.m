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
@property NSMutableDictionary *playerInfo;
@property NSMutableDictionary *productInfo;
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
        _playerInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayerInfo" ofType:@"plist"]];
        _productInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProductInfo" ofType:@"plist"]];
    }
    return self;
}

- (BOOL)isProductUnlocked:(NSString *)pId
{
    NSDictionary *product = [_productInfo objectForKey:pId];
    BOOL isUnlocked = ((NSNumber *)[product objectForKey:@"isUnlocked"]).boolValue;
    return isUnlocked;
}

- (NSArray *)buyableItemImageNames
{
    return nil;
}

- (BOOL)buyProductWithId:(NSString *)pId
{
    NSDictionary *product = [_productInfo objectForKey:pId];
    long price = ((NSNumber *)[product objectForKey:@"price"]).integerValue;
    long remainingAccount = ((NSNumber *)[_playerInfo objectForKey:@"account"]).integerValue - price;
    if (remainingAccount >= 0) {
        [_playerInfo setObject:[NSNumber numberWithLong:remainingAccount] forKey:@"account"];
        return YES;
    }else{
        return NO;
    }
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
//
//  NJStore.m
//  NinjaJump
//
//  Created by Wang Kunzhen on 24/5/14.
//  Copyright (c) 2014 Wang Kunzhen. All rights reserved.
//

#import "NJStore.h"

@implementation NJStore
- (BOOL)isProductUnlocked:(NSString *)pId
{
    if ([pId isEqualToString:kIceScrollProductId]) {
        return NO;
    }else if([pId isEqualToString:kThunderScrollProductId]){
        return NO;
    }else if([pId isEqualToString:kWindScrollProductId]){
        return NO;
    }else{
        return YES;
    }
}
@end

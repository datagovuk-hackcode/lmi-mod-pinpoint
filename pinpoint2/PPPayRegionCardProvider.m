//
//  PPPayRegionCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 09/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPPayRegionCardProvider.h"
#import "PPPayRegionCard.h"
#import "GRMustache.h"

@implementation PPPayRegionCardProvider

- (instancetype)initWithCardService:(PPCardService *)cardService {
    self = [super initWithCardService:cardService];
    if (self) {
        [self getRegionCodesFromAPI];
    }
    return self;
}

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences {
    if (userPreferences.likedJobs.count == 0) {
        return nil;
    }
    PPPayRegionCard *card = [[PPPayRegionCard alloc] initWithUserPreferences:userPreferences];
    NSString *socCode = [self getUnusedSocCodeFromArrayOfPossibles:userPreferences.likedJobs usingNSDefaultsKeyForUsedCodes:@"payRegionUsedSocCodes"];
    if (!socCode) {
        return nil;
    }
    [apiClient GET:@"ashe/estimatePay" parameters:@{@"soc":socCode, @"breakdown":@"region"} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *breakdown = responseDict[@"series"][0][@"breakdown"];
        for (int i = 0; i < breakdown.count; i++) {
//            NSMutableDictionary *mutableRegionAndPay = [breakdown[i] mutableCopy];
//            [mutableRegionAndPay setObject:[self getRegionNameFromCode:breakdown[i][@"region"]] forKey:@"regionName"];
//            [mutableRegionAndPay setObject:[self getRegionNameFromCode:breakdown[i][@"region"]] forKey:@"regionName"];
//            ((NSDictionary *)breakdown[i]) = mutableRegionAndPay;
        }
        [card addDataToCard:@{@"breakdown":breakdown}];
        [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", error);
    }];
    [apiClient GET:[NSString stringWithFormat:@"soc/code/%@", socCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *socDetails = (NSDictionary *)responseObject;
        [card addDataToCard:socDetails];
        [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"getting job details failed: %@", error);
    }];
    return card;
}

- (void)getRegionCodesFromAPI {
    [apiClient GET:@"ashe/filter/region" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        regionCodes = ((NSDictionary *)responseObject)[@"codings"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"getting job details failed: %@", error);
    }];
}
        
- (NSString *)getRegionNameFromCode:(NSString *)code {
    for (NSDictionary *regionCode in regionCodes) {
        if ([regionCode[@"value"] isEqualToString:code]) {
            return regionCode[@"name"];
        }
    }
    return nil;
}

- (NSString *)getAnnualPayFromWeeklyPay:(NSString *)weeklyPayString {
    int weeklyPay = [weeklyPayString intValue];
    int annualPay = weeklyPay*52;
    return [NSString stringWithFormat:@"%d", annualPay];
}

@end

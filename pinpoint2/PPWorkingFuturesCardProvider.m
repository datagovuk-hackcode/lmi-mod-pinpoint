//
//  PPWorkingFuturesCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPWorkingFuturesCardProvider.h"
#import "PPWorkingFuturesCard.h"

@implementation PPWorkingFuturesCardProvider

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences {
    if (userPreferences.likedJobs.count == 0) {
        return nil;
    }
    PPWorkingFuturesCard *card = [[PPWorkingFuturesCard alloc] initWithUserPreferences:userPreferences];
    NSString *socCode = [self getUnusedSocCodeFromArrayOfPossibles:userPreferences.likedJobs];
    [apiClient GET:@"wf/predict" parameters:@{@"soc":socCode} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *array = responseDict[@"predictedEmployment"];
        NSMutableArray *years = [[NSMutableArray alloc] init];
        NSMutableArray *workingFutures = [[NSMutableArray alloc] init];
        for (NSDictionary *yearOfData in array) {
            [years addObject:yearOfData[@"year"]];
            [workingFutures addObject:yearOfData[@"employment"]];
        }
        NSDictionary *dataDictionary = @{@"yearsCommaSeparatedList":[years componentsJoinedByString:@"','"], @"workingFuturesCommaSeparatedList": [workingFutures componentsJoinedByString:@","]};
        [card setHtmlWithDictionary:dataDictionary];
        [card setCardAsFinishedIfTheTemplateIsAllReplaced];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", error);
    }];
    [apiClient GET:[NSString stringWithFormat:@"soc/code/%@", socCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *socDetails = (NSDictionary *)responseObject;
        [card setHtmlWithDictionary:socDetails];
        [card setCardAsFinishedIfTheTemplateIsAllReplaced];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"getting job details failed: %@", error);
    }];
    return card;
}

- (NSString *)getUnusedSocCodeFromArrayOfPossibles:(NSArray *)socCodes {
    NSArray *usedCodes = [[NSUserDefaults standardUserDefaults] arrayForKey:@"workingFuturesUsedSocCodes"];
    if (!usedCodes) {
        usedCodes = [[NSSet alloc] init];
    }
    NSMutableArray *mutableSocCodes = [socCodes mutableCopy];
    [mutableSocCodes removeObjectsInArray:usedCodes];
    if (mutableSocCodes.count == 0) {
        return nil;
    }
    NSString *socCode = mutableSocCodes[arc4random_uniform(mutableSocCodes.count)][@"soc"];
    NSMutableArray *mutableUsedCodes = [usedCodes mutableCopy];
    [mutableUsedCodes addObject:socCode];
    [[NSUserDefaults standardUserDefaults] setObject:mutableUsedCodes forKey:@"workingFuturesUsedSocCodes"];
    return socCode;
}

@end

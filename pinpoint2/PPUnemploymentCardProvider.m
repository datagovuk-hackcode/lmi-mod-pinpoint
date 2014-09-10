//
//  PPUnemploymentCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 08/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUnemploymentCardProvider.h"
#import "PPUnemploymentCard.h"

@implementation PPUnemploymentCardProvider

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences {
    if (userPreferences.likedJobs.count == 0) {
        return nil;
    }
    PPUnemploymentCard *card = [[PPUnemploymentCard alloc] initWithUserPreferences:userPreferences];
    NSString *socCode = [self getUnusedSocCodeFromArrayOfPossibles:userPreferences.likedJobs usingNSDefaultsKeyForUsedCodes:@"unemploymentUsedSocCodes"];
    if (!socCode) {
        return nil;
    }
    [apiClient GET:@"lfs/unemployment" parameters:@{@"soc":socCode} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *array = responseDict[@"years"];
        NSMutableArray *years = [[NSMutableArray alloc] init];
        NSMutableArray *unemploymentRates = [[NSMutableArray alloc] init];
        for (NSDictionary *yearOfData in array) {
            [years addObject:yearOfData[@"year"]];
            [unemploymentRates addObject:yearOfData[@"unemprate"]];
        }
        NSDictionary *dataDictionary = @{@"yearsCommaSeparatedList":[years componentsJoinedByString:@"','"], @"unemploymentCommaSeparatedList": [unemploymentRates componentsJoinedByString:@","]};
        [card addDataToCard:dataDictionary];
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

@end

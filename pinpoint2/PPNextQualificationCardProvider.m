//
//  PPNextQualificationCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPNextQualificationCardProvider.h"
#import "PPNextQualificationCard.h"

@implementation PPNextQualificationCardProvider

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences {
    if (!userPreferences.currentQualificationLevel) {
        return nil;
    }
    PPNextQualificationCard *card = [[PPNextQualificationCard alloc] initWithUserPreferences:userPreferences];
    NSString *socCode = [self getUnusedSocCodeFromArrayOfPossibles:userPreferences.likedJobs usingNSDefaultsKeyForUsedCodes:@"nextQualificationUsedSocCodes"];
    if (!socCode) {
        return nil;
    }
    [apiClient GET:@"ashe/estimatePay" parameters:@{@"soc":socCode, @"breakdown":@"qualification"} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *breakdown = responseDict[@"series"][0][@"breakdown"];
        NSMutableArray *arrayOfReadableData = [[NSMutableArray alloc] init];
        for (NSDictionary *qualificationAndPay in breakdown) {
            int qualInt = [qualificationAndPay[@"qualification"] integerValue];
            int userQualInt = [userPreferences.currentQualificationLevel integerValue];
            if (qualInt < userQualInt || qualInt > userQualInt + 1) {
                //just want the data for current user qual and next qual up
                continue;
            }
            NSMutableDictionary *mutableQualificationAndPay = [qualificationAndPay mutableCopy];
            NSString *qualCodeString = [NSString stringWithFormat:@"%d", [qualificationAndPay[@"qualification"] integerValue]];
            [mutableQualificationAndPay setObject:[self getQualificationNameFromCode:qualCodeString] forKey:@"qualificationName"];
            [mutableQualificationAndPay setObject:[self getAnnualPayFromWeeklyPay:qualificationAndPay[@"estpay"]] forKey:@"yearlyPay"];
            [arrayOfReadableData addObject:mutableQualificationAndPay];
        }
        [card addDataToCard:@{@"payBreakdown":arrayOfReadableData}];
        [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", error);
    }];
    [apiClient GET:@"wf/predict/breakdown/qualification" parameters:@{@"soc":socCode} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *breakdown = responseDict[@"predictedEmployment"][0][@"breakdown"];
        NSMutableArray *arrayOfReadableData = [[NSMutableArray alloc] init];
        for (NSDictionary *qualificationAndEmployment in breakdown) {
            int qualInt = [qualificationAndEmployment[@"code"] integerValue];
            int userQualInt = [userPreferences.currentQualificationLevel integerValue];
            if (qualInt < userQualInt || qualInt > userQualInt + 1) {
                //just want the data for current user qual and next qual up
                continue;
            }
            NSMutableDictionary *mutableQualificationAndPay = [qualificationAndEmployment mutableCopy];
            NSString *qualCodeString = [NSString stringWithFormat:@"%d", [qualificationAndEmployment[@"code"] integerValue]];
            [mutableQualificationAndPay setObject:[self getQualificationNameFromCode:qualCodeString] forKey:@"qualificationName"];
            [mutableQualificationAndPay setObject:[NSString stringWithFormat:@"%ld", [qualificationAndEmployment[@"employment"] longValue]] forKey:@"numberOfJobsAvailable"];
            [arrayOfReadableData addObject:mutableQualificationAndPay];
        }
        [card addDataToCard:@{@"workingFuturesBreakdown":arrayOfReadableData}];
        [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", error);
    }];
    NSMutableArray *arrayOfReadableUnemploymentData = [[NSMutableArray alloc] init];
    [apiClient GET:@"lfs/unemployment" parameters:@{@"soc":socCode, @"nqf8":userPreferences.currentQualificationLevel} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *years = responseDict[@"years"];
        NSDictionary *yearOfUnemploymentData = [years lastObject];
        [arrayOfReadableUnemploymentData addObject:@{@"qualificationName":[self getQualificationNameFromCode:userPreferences.currentQualificationLevel], @"unemploymentRate":yearOfUnemploymentData[@"unemprate"]}];
        if (arrayOfReadableUnemploymentData.count == 2) {
            [card addDataToCard:@{@"unemploymentBreakdown":arrayOfReadableUnemploymentData}];
            [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", error);
    }];
    [apiClient GET:@"lfs/unemployment" parameters:@{@"soc":socCode, @"nqf8":@([userPreferences.currentQualificationLevel integerValue] + 1)} success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *responseDict = (NSDictionary *)response;
        NSArray *years = responseDict[@"years"];
        NSDictionary *yearOfUnemploymentData = [years lastObject];
        [arrayOfReadableUnemploymentData addObject:@{@"qualificationName":[self getQualificationNameFromCode:userPreferences.currentQualificationLevel], @"unemploymentRate":yearOfUnemploymentData[@"unemprate"]}];
        if (arrayOfReadableUnemploymentData.count == 2) {
            [card addDataToCard:@{@"unemploymentBreakdown":arrayOfReadableUnemploymentData}];
            [card setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml];
        }
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

- (NSString *)getQualificationNameFromCode:(NSString *)code {
    return [self qualificationNamesMappedToCodes][code];
}

- (NSString *)getAnnualPayFromWeeklyPay:(NSString *)weeklyPayString {
    int weeklyPay = (int)[weeklyPayString integerValue];
    int annualPay = weeklyPay*52;
    return [NSString stringWithFormat:@"%d", annualPay];
}

- (NSDictionary *)qualificationNamesMappedToCodes {
    return @{
             @"9":@"No Qualification",
             @"8":@"Below GCSE",
             @"7":@"GCSE",
             @"6":@"A Level",
             @"5":@"Diploma/Cert HE",
             @"4":@"Dip HE/Foundation Degree",
             @"3":@"Bachelors Degree",
             @"2":@"Masters",
             @"1":@"Doctorate"
             };
}

@end

//
//  PPCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCardProvider.h"
#import "PPCardService.h"

@implementation PPCardProvider

- (instancetype)initWithCardService:(PPCardService *)cardService {
    self = [self init];
    if (self) {
        [cardService registerAsACardProvider:self];
        apiClient = [PPAPIClient sharedInstance];
    }
    return self;
}

- (NSArray *)provideNumberOfCards:(NSInteger)numOfCards FromUserPreferences:(PPUserPreferences *)userPreferences {
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int x = 0; x < numOfCards; x ++) {
        [cards addObject:[self provideCardFromUserPreferences:userPreferences]];
    }
    return cards;
}

- (NSString *)getUnusedSocCodeFromArrayOfPossibles:(NSArray *)socCodes usingNSDefaultsKeyForUsedCodes:(NSString *) keyForUsedCodes {
    NSArray *usedCodes = [[NSUserDefaults standardUserDefaults] arrayForKey:keyForUsedCodes];
    if (!usedCodes) {
        usedCodes = [[NSArray alloc] init];
    }
    NSMutableArray *mutableSocCodes = [[NSMutableArray alloc] init];
    for (NSDictionary *job in socCodes) {
        [mutableSocCodes addObject:job[@"soc"]];
    }
    [mutableSocCodes removeObjectsInArray:usedCodes];
    if (mutableSocCodes.count == 0) {
        return nil;
    }
    NSString *socCode = mutableSocCodes[arc4random_uniform(mutableSocCodes.count)];
    NSMutableArray *mutableUsedCodes = [usedCodes mutableCopy];
    [mutableUsedCodes addObject:socCode];
    [[NSUserDefaults standardUserDefaults] setObject:mutableUsedCodes forKey:keyForUsedCodes];
    return socCode;
}



@end

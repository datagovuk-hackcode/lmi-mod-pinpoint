//
//  PPUserPreferencesStore.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPUserPreferences.h"

@interface PPUserPreferencesStore : NSObject {
    NSUserDefaults *defaults;
    NSInteger versionOfUserPreferences;
}

- (NSArray *)getArrayOfTopFiveKeywordsOrderedByPoints;
- (void)addPoints:(NSInteger)points forKeyword:(NSString *)keyword;
- (void)addLikedJobData:(NSDictionary *)jobData;
- (PPUserPreferences *)getCurrentUserPreferences;
- (void)saveCard:(NSObject *)card forSocCode:(NSString *)socCode;
- (NSArray *)getSavedCardsForSocCode:(NSString *)socCode;
- (bool)userPreferencesAreOutOfDate:(PPUserPreferences *)userPreferences;
+ (instancetype)sharedInstance;


@end

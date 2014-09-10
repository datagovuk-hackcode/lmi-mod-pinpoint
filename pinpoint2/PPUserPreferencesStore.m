//
//  PPUserPreferencesStore.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUserPreferencesStore.h"

@implementation PPUserPreferencesStore

- (id)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        versionOfUserPreferences = 0;
    }
    return  self;
}

- (void)addPoints:(NSInteger)points forKeyword:(NSString *)keyword {
    if ([defaults objectForKey:@"jobKeywords"] != nil) {
        NSMutableArray *mutableArrayOfKeywords = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"jobKeywords"]];
        bool isFoundInArray = NO;
        for (int x = 0; x < mutableArrayOfKeywords.count; x++) {
            if ([[mutableArrayOfKeywords[x] objectForKey:@"keyword"] isEqualToString:keyword]) {
                NSMutableDictionary *mutableDict = [mutableArrayOfKeywords[x] mutableCopy];
                [mutableDict setObject:@([[mutableDict objectForKey:@"points"] intValue] + points) forKey:@"points"];
                [mutableArrayOfKeywords removeObjectAtIndex:x];
                [mutableArrayOfKeywords insertObject:mutableDict atIndex:x];
                isFoundInArray = YES;
                break;
            }
        }
        if (!isFoundInArray){
            [mutableArrayOfKeywords addObject:@{@"keyword": keyword, @"points":@(points)}];
        }
        [defaults setObject:mutableArrayOfKeywords forKey:@"jobKeywords"];
    } else {
        [defaults setObject:[[NSMutableArray alloc] initWithArray:@[@{@"keyword": keyword, @"points":@(points)}]] forKey:@"jobKeywords"];
    }
    [self incrementVersionOfUserPreferences];
}

- (NSArray *)getArrayOfTopFiveKeywordsOrderedByPoints {
    NSMutableArray *arrayOfKeywordsAndPoints = [[defaults objectForKey:@"jobKeywords"] mutableCopy];
    [arrayOfKeywordsAndPoints sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"points" ascending:NO]]];
    NSMutableArray *keywords = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSDictionary *keywordAndPoints in arrayOfKeywordsAndPoints) {
        [keywords addObject:keywordAndPoints[@"keyword"]];
        if (keywords.count == 5) {
            return keywords;
        }
    }
    return keywords;
}

- (void) addLikedJobData:(NSDictionary *)jobData  {
    NSArray *likedJobs = [defaults objectForKey:@"likedJobs"];
    if (likedJobs == nil) {
        [defaults setObject:@[jobData] forKey:@"likedJobs"];
    } else {
        NSMutableArray *mutableJobs = [likedJobs mutableCopy];
        [mutableJobs addObject:jobData];
        [defaults setObject:mutableJobs forKey:@"likedJobs"];
    }
    [self incrementVersionOfUserPreferences];
}

- (PPUserPreferences *)getCurrentUserPreferences {
    PPUserPreferences *userPrefs = [[PPUserPreferences alloc] init];
    [userPrefs setLikedJobs:[defaults objectForKey:@"likedJobs"]];
    NSArray *jobKeyWords = [defaults objectForKey:@"jobKeywords"];
    if (jobKeyWords.count != 0) {
        [userPrefs setJobKeywords:[self getArrayOfTopFiveKeywordsOrderedByPoints]];
    }
    [userPrefs setVersionOfPreferences:@([self getVersionOfUserPreferences])];
    return userPrefs;
}

- (NSInteger)getVersionOfUserPreferences {
    return versionOfUserPreferences;
}

- (void)incrementVersionOfUserPreferences {
    versionOfUserPreferences++;
}

- (bool)userPreferencesAreOutOfDate:(PPUserPreferences *)userPreferences {
    if ([userPreferences.versionOfPreferences integerValue] + 5 < [self getVersionOfUserPreferences] ) {
        return true;
    }
    return false;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static PPUserPreferencesStore *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)getArrayOfKeywordsAndPointsOrderedByPoints{
    return nil;
}

@end

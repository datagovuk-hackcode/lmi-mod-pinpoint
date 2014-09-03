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
}

- (void)addPoints:(NSInteger)points forKeyword:(NSString *)keyword;
- (NSArray *)getArrayOfKeywordsAndPointsOrderedByPoints;
- (void)addLikedJobData:(NSDictionary *)jobData;
- (PPUserPreferences *)getCurrentUserPreferences;
+ (instancetype)sharedInstance;


@end

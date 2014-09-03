//
//  PPUserPreferences.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUserPreferences : NSObject

@property (strong, nonatomic) NSArray *jobKeywords;
@property (strong, nonatomic) NSNumber *isInterestedInQualifications;
@property (strong, nonatomic) NSString *currentQualificationLevel;
@property (strong, nonatomic) NSNumber *isInterestedInMoving;
@property (strong, nonatomic) NSArray *likedJobs;
@property (strong, nonatomic) NSString *socOfCurrentJob;

@property (strong, nonatomic) NSNumber *userPreferencesUpdateNumber;

@end

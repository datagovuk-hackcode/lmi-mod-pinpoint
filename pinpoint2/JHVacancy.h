//
//  JHVacancy.h
//  JobHappy
//
//  Created by Harry Jones on 06/02/2014.
//  Copyright (c) 2014 Harry Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JHVacancy : NSObject <CLLocationManagerDelegate>
- (JHVacancy*) initWithDictionary: (NSDictionary *)input;

@property (nonatomic) NSNumber *IDNumber;
@property (nonatomic) NSString *jobTitle;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *company;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@property (nonatomic) NSDictionary *location;

//@property (nonatomic) NSUInteger compatibilityRating;

@end

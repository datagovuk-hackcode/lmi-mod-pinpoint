//
//  JHVacancy.m
//  JobHappy
//
//  Created by Harry Jones on 06/02/2014.
//  Copyright (c) 2014 Harry Jones. All rights reserved.
//

#import "JHVacancy.h"
#import <CoreLocation/CoreLocation.h>


@implementation JHVacancy

#pragma mark Main
- (JHVacancy*) initWithDictionary: (NSDictionary *)input{
    self = [super init];
    NSDictionary *mapping = @{
                              @"IDNumber":@"id",
                              @"jobTitle":@"title",
                              @"summary":@"summary",
                              @"company":@"company",
                              @"location":@"location",
                              };
    for (NSString *key in mapping){
        if ([input objectForKey:[mapping objectForKey:key]]){
            [self setValue:[input objectForKey:[mapping objectForKey:key]] forKey:key];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    self.startDate = [dateFormatter dateFromString:[[input objectForKey:@"activedate"] objectForKey:@"start"]];
    self.endDate   = [dateFormatter dateFromString:[[input objectForKey:@"activedate"] objectForKey:@"end"]];
    return self;
}
@end

//
//  PPUserPreferences.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUserPreferences.h"

@implementation PPUserPreferences

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.jobKeywords forKey:@"jobKeywords"];
    [coder encodeObject:self.isInterestedInQualifications forKey:@"isInterestedInQualifications"];
    [coder encodeObject:self.currentQualificationLevel forKey:@"currentQualificationLevel"];
    [coder encodeObject:self.isInterestedInMoving forKey:@"isInterestedInMoving"];
    [coder encodeObject:self.likedJobs forKey:@"likedJobs"];
    [coder encodeObject:self.socOfCurrentJob forKey:@"socOfCurrentJob"];
    [coder encodeObject:self.versionOfPreferences forKey:@"versionOfPreferences"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[PPUserPreferences alloc] init];
    if (self != nil)
    {
        self.jobKeywords = [coder decodeObjectForKey:@"jobKeywords"];
        self.isInterestedInQualifications = [coder decodeObjectForKey:@"isInterestedInQualifications"];
        self.currentQualificationLevel = [coder decodeObjectForKey:@"currentQualificationLevel"];
        self.isInterestedInMoving = [coder decodeObjectForKey:@"isInterestedInMoving"];
        self.likedJobs = [coder decodeObjectForKey:@"likedJobs"];
        self.socOfCurrentJob = [coder decodeObjectForKey:@"socOfCurrentJob"];
        self.versionOfPreferences = [coder decodeObjectForKey:@"versionOfPreferences"];
    }
    return self;
}

@end

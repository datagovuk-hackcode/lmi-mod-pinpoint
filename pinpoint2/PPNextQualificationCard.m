//
//  PPNextQualificationCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPNextQualificationCard.h"

@implementation PPNextQualificationCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.html = [self getHtmlTemplateStringFromName:@"next-qualification-card"];
    }
    return self;
}

- (void)handleLike {
    [super handleLike];
}

- (void)handleDislike {
    
}

- (NSArray *)listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade {
    return @[@"title", @"payBreakdown", @"workingFuturesBreakdown", @"unemploymentBreakdown"];
}

@end

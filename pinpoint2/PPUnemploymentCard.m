//
//  PPUnemploymentCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 08/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUnemploymentCard.h"

@implementation PPUnemploymentCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.html = [self getHtmlTemplateStringFromName:@"unemployment-card"];
    }
    return self;
}

- (void)handleLike {
    
}

- (void)handleDislike {
    
}

- (NSArray *)listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade {
    return @[@"title", @"unemploymentCommaSeparatedList"];
}

@end

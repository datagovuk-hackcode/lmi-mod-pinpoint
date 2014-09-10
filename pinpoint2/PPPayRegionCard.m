//
//  PPPayRegionCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 09/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPPayRegionCard.h"

@implementation PPPayRegionCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.html = [self getHtmlTemplateStringFromName:@"working-futures-card"];
    }
    return self;
}

- (void)handleLike {
    
}

- (void)handleDislike {
    
}

- (NSArray *)listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade {
    return @[@"title", @"workingFuturesCommaSeparatedList"];
}

@end

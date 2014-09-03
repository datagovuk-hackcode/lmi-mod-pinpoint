//
//  PPCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCardProvider.h"
#import "PPCardService.h"

@implementation PPCardProvider

- (instancetype)initWithCardService:(PPCardService *)cardService {
    self = [self init];
    if (self) {
        [cardService registerAsACardProvider:self];
        apiClient = [PPAPIClient sharedInstance];
    }
    return self;
}

- (NSArray *)provideNumberOfCards:(NSInteger)numOfCards FromUserPreferences:(PPUserPreferences *)userPreferences {
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int x = 0; x < numOfCards; x ++) {
        [cards addObject:[self provideCardFromUserPreferences:userPreferences]];
    }
    return cards;
}

@end

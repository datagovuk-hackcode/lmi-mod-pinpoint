//
//  PPNonHtmlCardProvider.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPNonHtmlCardProvider.h"
#import "PPQualificationQuestionCard.h"

@implementation PPNonHtmlCardProvider

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences {
    if (!userPreferences.currentQualificationLevel && !hasSentQualificationsQuestion) {
        PPQualificationQuestionCard *card = [[PPQualificationQuestionCard alloc] init];
        hasSentQualificationsQuestion = YES;
        return card;
    }
    return nil;
}

@end

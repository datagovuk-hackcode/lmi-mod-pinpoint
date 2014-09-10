//
//  PPJobCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 27/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPJobCard.h"
#import "PPUserPreferencesStore.h"

@implementation PPJobCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.html = [self getHtmlTemplateStringFromName:@"job-card"];
    }
    return self;
}

- (void)handleLike {
    [super handleLike];
    NSArray *keywordGroups = self.data[@"add_titles"];
    for (NSString *keywordGroup in keywordGroups) {
        NSArray *keywordsInGroup = [keywordGroup componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" )(-,;"]];
        for (NSString *keyword in keywordsInGroup) {
            if (![keyword isEqualToString:@""] && keyword != nil) {
                [userPrefsStore addPoints:1 forKeyword:keyword];
            }
        }
    }
    [userPrefsStore addLikedJobData:self.data];
}

- (void)handleDislike {
    [super handleDislike];
    NSArray *keywordGroups = self.data[@"add_titles"];
    for (NSString *keywordGroup in keywordGroups) {
        NSArray *keywordsInGroup = [keywordGroup componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" )(-,;"]];
        for (NSString *keyword in keywordsInGroup) {
            if (![keyword isEqualToString:@""] && keyword != nil) {
                [userPrefsStore addPoints:-1 forKeyword:keyword];
            }
        }
    }
}

- (bool)cardCanBeOutOfDate {
    return YES;
}

@end

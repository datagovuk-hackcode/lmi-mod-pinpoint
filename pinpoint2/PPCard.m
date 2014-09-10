//
//  PPCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCard.h"
#import "PPUserPreferences.h"
#import "GRMustache.h"
#import "PPMultipleApiCallCard.h"

@interface PPCard () {
    GRMustacheTemplate *htmlTemplate;
}
@end

@implementation PPCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isFinished = @(NO);
        userPrefsStore = [PPUserPreferencesStore sharedInstance];
    }
    return self;
}

- (instancetype)initWithUserPreferences:(PPUserPreferences *)userPrefs {
    self = [self init];
    if (self) {
        [self setUserPreferences:userPrefs];
    }
    return self;
}

- (void)setHtmlWithDictionary:(NSDictionary *)dataDictionary {
    for (NSString *dataKey in dataDictionary) {
        NSRange rangeOfDataKey = [self.html rangeOfString:[NSString stringWithFormat:@"{{%@}}", dataKey] options:NSCaseInsensitiveSearch];
        if (rangeOfDataKey.location != NSNotFound) {
            self.html = [self.html stringByReplacingCharactersInRange:rangeOfDataKey withString:dataDictionary[dataKey]];
        }
    }
    self.data = dataDictionary;
}

- (void)renderDataInHtml:(NSDictionary *)data {
    NSError *error = nil;
    htmlTemplate = [GRMustacheTemplate templateFromString:self.html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    self.html = [htmlTemplate renderObject:data error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
}

- (NSString *)getHtmlTemplateStringFromName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *htmlString = [[NSString alloc] initWithData:
                            [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    return htmlString;
}

- (void)setCardAsFinishedIfTheTemplateIsAllReplaced {
    NSError *error = nil;
    NSRegularExpression *templateRegex = [NSRegularExpression regularExpressionWithPattern:@"{{.*}}" options:0 error:&error];
    NSArray *matches = [templateRegex matchesInString:self.html options:NSMatchingReportCompletion range:NSMakeRange(0, self.html.length)];
    if (matches.count == 0) {
        self.isFinished = @(YES);
    }
}

- (void)addDataToCard:(NSDictionary *)dataDictionary {
    if (!self.data) {
        self.data = [[NSDictionary alloc] init];
    }
    NSMutableDictionary *mutableData = [self.data mutableCopy];
    [mutableData addEntriesFromDictionary:dataDictionary];
    self.data = mutableData;
}

- (void)setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml {
    if ([self isAllDataPresent]) {
        [self renderDataInHtml:self.data];
        [self setIsFinished:@(YES)];
    }
}

- (bool)isAllDataPresent {
    NSArray *keys = [self listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade];
    NSArray *keysInCurrentData = [self.data allKeys];
    for (NSString *key in keys) {
        if (![keysInCurrentData containsObject:key]) {
            return false;
        }
    }
    return true;
}
         
         
 - (NSArray *)listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade {
     return @[];
 }

- (bool)cardCanBeOutOfDate {
    return NO;
}

- (void)handleLike {}
- (void)handleDislike {}

@end

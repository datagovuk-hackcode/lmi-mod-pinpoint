//
//  PPCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCard.h"
#import "PPUserPreferences.h"

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

@end

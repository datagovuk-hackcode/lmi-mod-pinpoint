//
//  PPCard.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPUserPreferences.h"
#import "PPUserPreferencesStore.h"
#import "PPDismissableCard.h"
#import "PPCardRelevancy.h"
#import "PPMultipleApiCallCard.h"

typedef NS_ENUM(NSInteger, PPCardType) {
    PPCardTypeJob,
    PPCardTypeWorkingFutures
};

@interface PPCard : NSObject <PPDismissableCard, PPCardRelevancy, PPMultipleApiCallCard> {
    PPUserPreferencesStore *userPrefsStore;
}

@property (nonatomic) PPCardType cardType;
@property (strong, nonatomic) NSString *html;
@property (nonatomic, strong) NSNumber *isFinished;
@property (nonatomic, strong) PPUserPreferences *userPreferences;
@property (nonatomic, strong) NSDictionary *data;

- (instancetype)initWithUserPreferences:(PPUserPreferences *)userPrefs;
- (void)addDataToCard:(NSDictionary *)dataDictionary;
- (void)setCardAsFinishedIfDataIsAllPresentAndRenderTheHtml;
- (NSString *)getHtmlTemplateStringFromName:(NSString *)name;

@end

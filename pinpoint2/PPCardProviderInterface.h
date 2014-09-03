//
//  PPCardProvider.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPCard.h"
#import "PPUserPreferences.h"

@protocol PPCardProviderInterface <NSObject>

- (PPCard *)provideCardFromUserPreferences:(PPUserPreferences *)userPreferences;
- (NSArray *)provideNumberOfCards:(NSInteger)numOfCards FromUserPreferences:(PPUserPreferences *)userPreferences;

@end

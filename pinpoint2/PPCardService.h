//
//  PPCardService.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPUserPreferences.h"
#import "PPCardProviderInterface.h"

@interface PPCardService : NSObject {
    NSMutableArray *cardsFinished;
    NSMutableArray *cardsUnfinished;
    NSMutableArray *cardProviders;
    NSTimer *timer;
}

- (NSArray *)getNumberOfCards:(NSInteger)numOfCards;

- (void)registerAsACardProvider:(id<PPCardProviderInterface>)cardProvider;

+ (instancetype)sharedInstance;

@end

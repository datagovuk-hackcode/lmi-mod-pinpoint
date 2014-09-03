//
//  PPCardService.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCardService.h"

@implementation PPCardService

- (instancetype)init {
    self = [super init];
    if (self) {
        cardsFinished = [[NSMutableArray alloc] init];
        cardsUnfinished = [[NSMutableArray alloc] init];
        cardProviders = [[NSMutableArray alloc] init];
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(getCardsFromProviders) userInfo:nil repeats:YES];
    }
    return self;
}

- (NSArray *)getNumberOfCards:(NSInteger)numOfCards {
    NSArray *cardsToReturn = @[];
    if (cardsFinished.count < numOfCards) {
        cardsToReturn = [NSArray arrayWithArray:cardsFinished];
        [cardsFinished removeAllObjects];
    } else {
        cardsToReturn = [NSArray arrayWithArray:[cardsFinished objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numOfCards)]]];
        [cardsFinished removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numOfCards)]];
    }
    return cardsToReturn;
}

- (void)registerAsACardProvider:(id<PPCardProviderInterface>)cardProvider {
    [cardProviders addObject:cardProvider];
}

- (void)getCardsFromProviders {
    if (![self userPreferencesAreDifferentToCurrentCards]) {
        return;
    }
    for (id<PPCardProviderInterface> cardProvider in cardProviders) {
        PPCard *card = [cardProvider provideCardFromUserPreferences:[[PPUserPreferencesStore sharedInstance] getCurrentUserPreferences]];
        if ([[card isFinished] boolValue] && ![cardsFinished containsObject:card]) {
            [cardsFinished addObject:card];
        } else if (card) {
            [cardsUnfinished addObject:card];
        }
        [card addObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished)) options:0 context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[PPCard class]]) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {
            if (![cardsFinished containsObject:object]) {
                [cardsFinished addObject:object];
            }
            [cardsUnfinished removeObject:object];
            [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished))];
        }
    }
}

- (bool)userPreferencesAreDifferentToCurrentCards {
    //TODO implement
    return YES;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static PPCardService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end

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
    cardsFinished = [self removeOutOfDateCardsFromCardArray:cardsFinished];
    if ([self weHaveEnoughFinishedCards]) {
        return;
    }
    for (id<PPCardProviderInterface> cardProvider in cardProviders) {
        PPCard *card = [cardProvider provideCardFromUserPreferences:[[PPUserPreferencesStore sharedInstance] getCurrentUserPreferences]];
        if ([[card isFinished] boolValue] && ![cardsFinished containsObject:card]) {
            [cardsFinished insertObject:card atIndex:arc4random_uniform((uint)cardsFinished.count)];
        } else if (card) {
            [cardsUnfinished addObject:card];
            [card addObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished)) options:0 context:NULL];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[PPCard class]]) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFinished))]) {
            if (![cardsFinished containsObject:object]) {
                [cardsFinished insertObject:object atIndex:arc4random_uniform((uint)cardsFinished.count)];
            }
            [cardsUnfinished removeObject:object];
            [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFinished))];
        }
    }
}

- (bool)userPreferencesAreDifferentToCard:(PPCard *)card {
    return [[PPUserPreferencesStore sharedInstance] userPreferencesAreOutOfDate:card.userPreferences];
}

- (bool)weHaveEnoughFinishedCards {
    NSLog(@"number of cards ready to go: %d", (uint)cardsFinished.count);
    return cardsFinished.count > 4;
}

- (NSMutableArray *)removeOutOfDateCardsFromCardArray:(NSMutableArray *)cards {
    for (int i = 0; i < cards.count; i++) {
        if ([cards[i] cardCanBeOutOfDate] && [self userPreferencesAreDifferentToCard:cards[i]]) {
            [cards removeObjectAtIndex:i];
            i--;
        }
    }
    return cards;
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

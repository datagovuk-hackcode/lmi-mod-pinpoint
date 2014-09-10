//
//  PPNonHtmlCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPNonHtmlCard.h"

@implementation PPNonHtmlCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardType = PPcardTypeNonHtml;
        self.isFinished = @(YES);
    }
    return self;
}

- (void)handleLike {
    
}

- (void)handleDislike {
    
}

- (bool)cardCanBeOutOfDate {
    return NO;
}

@end

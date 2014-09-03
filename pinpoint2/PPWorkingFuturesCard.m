//
//  PPWorkingFuturesCard.m
//  pinpoint2
//
//  Created by Philip Hardwick on 27/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPWorkingFuturesCard.h"

@implementation PPWorkingFuturesCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.html = [self getHtmlTemplateStringFromName:@"working-futures-card"];
    }
    return self;
}

- (void)handleLike {
    
}

- (void)handleDislike {
    
}

@end

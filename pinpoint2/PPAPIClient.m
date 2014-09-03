//
//  PPAPIClient.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPAPIClient.h"

@implementation PPAPIClient

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static PPAPIClient *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.lmiforall.org.uk/api/v1/"]];
        sharedInstance.requestSerializer = [AFJSONRequestSerializer new];
        sharedInstance.responseSerializer = [AFJSONResponseSerializer new];
    });
    return sharedInstance;
}

@end


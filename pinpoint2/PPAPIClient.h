//
//  PPAPIClient.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface PPAPIClient : AFHTTPRequestOperationManager

+(instancetype)sharedInstance;

@end

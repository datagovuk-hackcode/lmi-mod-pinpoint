//
//  PPCardProvider.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPCardProviderInterface.h"
#import "PPAPIClient.h"
#import "PPCardService.h"

@interface PPCardProvider : NSObject <PPCardProviderInterface> {
    PPAPIClient *apiClient;
}

- (instancetype)initWithCardService:(PPCardService *)cardService;

@end

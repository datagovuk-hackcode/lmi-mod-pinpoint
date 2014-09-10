//
//  PPMultipleApiCallCard.h
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPMultipleApiCallCard <NSObject>

@required
- (NSArray *)listOfDataKeysThatMustBePresentToIndicateThatAllCallsToApiHaveBeenMade;

@end

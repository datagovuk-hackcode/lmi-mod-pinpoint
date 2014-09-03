//
//  PPDismissableCard.h
//  pinpoint2
//
//  Created by Philip Hardwick on 27/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPDismissableCard <NSObject>

- (void)handleLike;
- (void)handleDislike;

@end

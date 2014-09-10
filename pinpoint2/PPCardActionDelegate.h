//
//  PPCardActionDelegate.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPCardCollectionViewCell;

@protocol PPCardActionDelegate <NSObject>

- (void)cardWasSwipedLeft:(PPCardCollectionViewCell *)cardCell;
- (void)cardWasSwipedRight:(PPCardCollectionViewCell *)cardCell;

@optional
- (void)cardDidBeginPanning:(PPCardCollectionViewCell *)cardCell;
- (void)cardDidEndPanning:(PPCardCollectionViewCell *)cardCell;

@end

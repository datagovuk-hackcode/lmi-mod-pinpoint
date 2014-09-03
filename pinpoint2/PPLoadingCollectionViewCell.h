//
//  PPLoadingCollectionViewCell.h
//  pinpoint2
//
//  Created by Philip Hardwick on 27/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLoadingCollectionViewCell : UICollectionReusableView

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *loadMoreButton;

- (void)setIntoLoadingModeView;
- (void)setIntoLoadedModeView;

@end

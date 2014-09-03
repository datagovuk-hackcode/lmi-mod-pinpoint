//
//  PPLoadingCollectionViewCell.m
//  pinpoint2
//
//  Created by Philip Hardwick on 27/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPLoadingCollectionViewCell.h"

@implementation PPLoadingCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIntoLoadingModeView {
    [self.activityIndicator startAnimating];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setIntoLoadedModeView {
    [self.activityIndicator stopAnimating];
    [self setBackgroundColor:[UIColor orangeColor]];
    [self.loadMoreButton setHidden:NO];
}

@end

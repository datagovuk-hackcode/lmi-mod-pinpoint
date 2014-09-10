//
//  PPUserCardCell.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUserCardCell.h"

@implementation PPUserCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCard {
    NSString *baseUrlPath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:baseUrlPath];
    [self.webView loadHTMLString:self.card.html baseURL:baseURL];
    [self setUpCardLook];
}

- (void)setUpCardLook {
    [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    CALayer *contentViewlayer = [[self contentView] layer];
    CALayer *celllayer = [self layer];
    [contentViewlayer setMasksToBounds:YES];
    [contentViewlayer setCornerRadius:2.0f];
    [contentViewlayer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [contentViewlayer setShouldRasterize:YES];
    [celllayer setShadowColor:[[UIColor blackColor] CGColor]];
    [celllayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [celllayer setShadowRadius:6.0f];
    [celllayer setShadowOpacity:0.3f];
    [celllayer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:2.0f] CGPath]];
}

@end

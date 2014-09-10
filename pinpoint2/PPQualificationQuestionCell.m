//
//  PPQualificationQuestionCell.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPQualificationQuestionCell.h"
#import "PPUserPreferencesStore.h"

@implementation PPQualificationQuestionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCard {
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

- (void)qualificationSelected:(UIButton *)sender {
    NSString *code = [self qualificationNamesMappedToCodes][sender.titleLabel.text];
    [[PPUserPreferencesStore sharedInstance] setCurrentQualificationCodeNumber:code];
    [self.cellDismisserDelegate dismissCell:self];
}

- (NSDictionary *)qualificationNamesMappedToCodes {
    return @{
             @"No Qualification":@"9",
             @"Below GCSE":@"8",
             @"GCSE": @"7",
             @"A Levels": @"6",
             @"Diploma/Cert HE": @"5",
             @"Dip HE/Foundation Degree":@"4",
             @"Bachelors Degree":@"3",
             @"Masters":@"2",
             @"Doctorate":@"1"
             };
}

@end

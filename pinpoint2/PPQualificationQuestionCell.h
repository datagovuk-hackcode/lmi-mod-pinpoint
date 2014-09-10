//
//  PPQualificationQuestionCell.h
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCellDismisser.h"

@interface PPQualificationQuestionCell : UICollectionViewCell

- (IBAction)qualificationSelected:(UIButton *)sender;
- (void)configureCard;

@property (weak) id<PPCellDismisser> cellDismisserDelegate;

@end

//
//  PPCardCollectionViewController.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCardActionDelegate.h"
#import "PPCardService.h"
#import "PPCellDismisser.h"

@interface PPCardCollectionViewController : UICollectionViewController <PPCardActionDelegate, PPCellDismisser>

@property (strong, nonatomic) PPCardService *cardService;
@property (strong, nonatomic) NSMutableArray *cards;

- (IBAction)loadMoreCards:(id)sender;

@end

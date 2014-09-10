//
//  PPUserCardCollectionViewController.h
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCardService.h"

@interface PPUserCardCollectionViewController : UICollectionViewController

@property (strong, nonatomic) PPCardService *cardService;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSString *socCode;

@end

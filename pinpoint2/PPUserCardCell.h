//
//  PPUserCardCell.h
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCard.h"

@interface PPUserCardCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PPCard *card;

- (void)configureCard;

@end

//
//  PPCardCollectionViewCell.h
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCardActionDelegate.h"
#import "PPCard.h"

@interface PPCardCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (assign, setter = setDeleted:) BOOL isDeleted;
@property (strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) id <PPCardActionDelegate> cardActionDelegate;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PPCard *card;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *webViewLoadingIndicator;

- (void)configureCard;
- (void)undoDelete;

@end

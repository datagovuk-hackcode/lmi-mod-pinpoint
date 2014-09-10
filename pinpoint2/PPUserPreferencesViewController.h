//
//  PPUserPreferencesViewController.h
//  pinpoint2
//
//  Created by Philip Hardwick on 02/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPUserPreferencesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *keywordsTextView;
@property (nonatomic, retain) IBOutlet UITextView *likedJobsTextView;

@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end

//
//  PPUserPreferencesViewController.m
//  pinpoint2
//
//  Created by Philip Hardwick on 02/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUserPreferencesViewController.h"
#import "PPUserPreferencesStore.h"
#import "PPUserPreferences.h"

@interface PPUserPreferencesViewController ()

@end

@implementation PPUserPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PPUserPreferences *userPrefs = [[PPUserPreferencesStore sharedInstance] getCurrentUserPreferences];
    [self.keywordsTextView setText:[userPrefs.jobKeywords componentsJoinedByString:@"\n"]];
    [self.likedJobsTextView setText:[userPrefs.likedJobs componentsJoinedByString:@"\n"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

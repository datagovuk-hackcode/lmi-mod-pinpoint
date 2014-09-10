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
#import "PPUserCardCollectionViewController.h"

@interface PPUserPreferencesViewController () {
    PPUserPreferences *userPrefs;
}

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
    userPrefs = [[PPUserPreferencesStore sharedInstance] getCurrentUserPreferences];
    [self.keywordsTextView setText:[userPrefs.jobKeywords componentsJoinedByString:@"\n"]];
    [self.likedJobsTextView setText:[userPrefs.likedJobs componentsJoinedByString:@"\n"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userPrefs.likedJobs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = userPrefs.likedJobs[indexPath.row][@"title"];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"userCardsSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PPUserCardCollectionViewController *vc = [segue destinationViewController];
        [vc setSocCode:userPrefs.likedJobs[indexPath.row][@"soc"]];
    }
}


@end

//
//  PPVacanciesTableViewController.m
//
//
//  Created by Harry Jones on 23/06/2014.
//
//

#import "PPVacanciesTableViewController.h"
#import "JHVacancy.h"
#import "JHVacancyDetailViewController.h"
#import "PPAPIClient.h"
#import "PPUserPreferencesStore.h"

@implementation PPVacanciesTableViewController{
    PPAPIClient *apiClient;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Horrible hack. See http://stackoverflow.com/questions/18900428/ios-7-uitableview-shows-under-status-bar
    // Quickest way to get UITableVC w/ tabs to not go under status bar.
    //self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    
    self.tableData = [[NSMutableArray alloc] init];
    apiClient = [PPAPIClient sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.tableData.count == 0){
        PPUserPreferencesStore *prefStore = [[PPUserPreferencesStore alloc] init];
        NSArray *topKeywords = [prefStore getArrayOfTopFiveKeywordsOrderedByPoints];
        if (topKeywords.count < 1){
            NSLog(@"No keywords...");
            return;
        }
        NSString *favouriteKeyword = topKeywords[0];
        NSString *secondFavouriteKeyword = topKeywords.count >=1 ? topKeywords[1] : nil;
        if (favouriteKeyword == nil) {
            
        } else {
            if (secondFavouriteKeyword == nil){
                [self searchForString:favouriteKeyword];
                NSLog(@"Finding jobs for keyword '%@'",favouriteKeyword);
            }else{
                [self searchForString:[NSString stringWithFormat:@"%@ OR %@",favouriteKeyword,secondFavouriteKeyword]];
                NSLog(@"Finding jobs for keywords '%@' and '%@'", favouriteKeyword, secondFavouriteKeyword);
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)searchForString:(NSString *)searchString{
    [self.tableData setArray:@[]];
    [[self tableView] reloadData]; // Blank out the table while data is loading
    
    //[searchBar setShowsCancelButton:NO animated:YES];
    //    [ProgressHUD show:Nil Interaction:NO]; // Show the progress HUD with no tex
    
    [apiClient GET:@"vacancies/search" parameters:@{@"keywords":searchString} success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSArray *array = responseObject;
        if (![array isKindOfClass:NSArray.class]){
            NSAssert(NO, @"Incorrect data recieved, expected an NSArray and got %@ instead", NSStringFromClass([responseObject class]));
        }
        if ([array count] == 0){ // If we get no results
            dispatch_async(dispatch_get_main_queue(), ^(void) { // ALL UI STUFF MUST HAPPEN ON MAIN THREAD.
                //                [ProgressHUD showError:@"No Results Found"];
                NSLog(@"NO RESULTS FOUND");
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void) { // ALL UI STUFF MUST HAPPEN ON MAIN THREAD.
                for (NSDictionary *vacancy in array){ // For every career that is returned
                    JHVacancy* vacancyObject = [[JHVacancy alloc] initWithDictionary:vacancy];
                    //                    NSLog(@"Object: %@",vacancyObject.jobTitle);
                    [_tableData addObject:vacancyObject]; // Append it to the tableData
                }
                [[self tableView] reloadData]; // Reload the table with all the new data
                //                [ProgressHUD dismiss]; // Hide the loading indicator
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"getting job details failed: %@", error);
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vacancyCell" forIndexPath:indexPath];
    
    JHVacancy *vacancy = (JHVacancy *)[_tableData objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:vacancy.jobTitle];
    
    NSString *postcode = [vacancy.location objectForKey:@"postcode"];
    NSString *area = [vacancy.location objectForKey:@"area"];
    NSString *city = [vacancy.location objectForKey:@"city"];
    NSString *country = [vacancy.location objectForKey:@"country"];
    
    postcode = postcode ? [NSString stringWithFormat:@"%@, ",postcode] : @"";
    area = area && ![area isEqualToString:city] ? [NSString stringWithFormat:@"%@ ",area] : @"";
    city = city ? [NSString stringWithFormat:@"%@, ",city] : @"";
    country = country ? [NSString stringWithFormat:@"%@ ",country] : @"";
    
    NSString *locationString = [NSString stringWithFormat:@"%@%@%@%@\n",postcode , area, city, country];
    
    [cell.detailTextLabel setText:[locationString stringByReplacingOccurrencesOfString:@", \n" withString:@""]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    JHVacancyDetailViewController *vacancyVC = [segue destinationViewController];
    vacancyVC.vacancyObject = [_tableData objectAtIndex:[[[self tableView] indexPathForCell:sender]row]];
    
    // Pass the career over to the next VC, so it knows what's up
}


@end

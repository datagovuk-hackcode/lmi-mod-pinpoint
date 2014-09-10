//
//  JHVacancyDetailViewController.m
//  JobHappy
//
//  Created by Harry Jones on 08/02/2014.
//  Copyright (c) 2014 Harry Jones. All rights reserved.
//

#import "JHVacancyDetailViewController.h"
#import "MKMapView+ZoomLevel.h"
#import <CoreLocation/CoreLocation.h>
#import <MarqueeLabel.h>
#import <MapKit/MapKit.h>
//#import "ProgressHUD.h"

@interface JHVacancyDetailViewController()

@property (nonatomic) MKMapView *mapView;

@end

@implementation JHVacancyDetailViewController
@synthesize vacancyObject,modelLayout,cellTypes,cellActions;

#pragma mark UIView
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    cellActions = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
    modelLayout = @[
                    @{
                        @"title":@"Details",
                        @"members":@[
                                @{
                                    @"type":@"title",
                                    @"title":@"Title",
                                    @"source":@"jobTitle"
                                    },
                                @{
                                    @"type":@"basic",
                                    @"title":@"Company",
                                    @"source":@"company"
                                    },
                                @{
                                    @"type":@"basic",
                                    @"title":@"Posted",
                                    @"source":@"startDate"
                                    },
                                @{
                                    @"type":@"basic",
                                    @"title":@"Available Until",
                                    @"source":@"endDate"
                                    },
                                ]
                        },
                    @{
                        @"title":@"Description",
                        @"members":@[
                                @{
                                    @"type":@"text-based",
                                    @"title":@"Description",
                                    @"source":@"summary",
                                    @"sourceFormat":@"%@..."
                                    }
                                ]
                        },
                    @{
                        @"title":@"Location",
                        @"members":@[
                                @{
                                    @"type":@"map",
                                    @"title":@"Location",
                                    @"getter":^(void(^completion)(CLPlacemark *placemark, NSString *placemarkTitle)){
                                        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                                        
                                        NSString *postcode = [[vacancyObject.location objectForKey:@"postcode"] uppercaseString];
                                        NSString *area = [vacancyObject.location objectForKey:@"area"];
                                        NSString *city = [vacancyObject.location objectForKey:@"city"];
                                        NSString *country = [vacancyObject.location objectForKey:@"country"];
                                        
                                        postcode = postcode ? [NSString stringWithFormat:@"%@, ",postcode] : @"";
                                        area = area && ![area isEqualToString:city] && ![area isEqualToString:@"HC"]? [NSString stringWithFormat:@"%@ ",area] : @"";
                                        city = city ? [NSString stringWithFormat:@"%@, ",city] : @"";
                                        country = country ? [NSString stringWithFormat:@"%@ ",country] : @"";
                                        
                                        NSString *locationString = [NSString stringWithFormat:@"%@%@%@%@\n",postcode , area, city, country];
                                        
                                        [geocoder geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
                                            completion([placemarks lastObject], locationString);
                                        }];
                                        
                                    }
                                    }
                                ]
                        },
                    @{
                        @"title":@"Other",
                        @"members":@[
                                @{
                                    @"type":@"link",
                                    @"title":@"More information",
                                    @"subtitle":@"Open in browser",
                                    @"action":^{
                                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://jobsearch.direct.gov.uk/GetJob.aspx?JobID=%@",vacancyObject.IDNumber]];
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                    },
                                ]
                        }
                    ];
    if (!vacancyObject){
        NSLog(@"No vacancy object passed...");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)appReturnsActive{
    [self.mapView setShowsUserLocation:YES];
}

-(void)appToBackground{
    [self.mapView setShowsUserLocation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [MarqueeLabel restartLabelsOfController:self];
    
}

#pragma mark Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [modelLayout count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[modelLayout objectAtIndex:section] objectForKey:@"members"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *model = [[[modelLayout objectAtIndex:indexPath.section]objectForKey:@"members"]objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [model objectForKey:@"type"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:2];
    MarqueeLabel *detailLabelMarquee = (MarqueeLabel *)[cell viewWithTag:3];
    
    detailLabelMarquee.fadeLength = 5;
    detailLabelMarquee.rate = 25;
    detailLabelMarquee.animationDelay = 2;
    detailLabelMarquee.textAlignment = NSTextAlignmentRight;
    
    [titleLabel setText:[model objectForKey:@"title"]];
    if ([model objectForKey:@"source"] != Nil && ![[model objectForKey:@"type"] isEqualToString:@"map"] && ![[model objectForKey:@"type"] isEqualToString:@"link"] ){
        id input = [vacancyObject valueForKey:[model objectForKey:@"source"]];
        NSString *text;
        if ([input  isKindOfClass:[NSDate class]]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            text = [dateFormatter stringFromDate:input];
        }else{
            text=[NSString stringWithFormat:[model objectForKey:@"sourceFormat"] ? [model objectForKey:@"sourceFormat"]  : @"%@", input];
        }
        [detailLabelMarquee setText: text];
        [detailLabel setText:text];
    }else if ([model objectForKey:@"getter"] != Nil && [[model objectForKey:@"type"] isEqualToString:@"map"]){
        void(^getter)(CLPlacemark *placemark) = [model objectForKey:@"getter"];
        getter(^(CLPlacemark *placemark,  NSString *placemarkTitle){
            MKMapView *map = (MKMapView *)[cell viewWithTag:106];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coordinate];
            [annotation setTitle:placemarkTitle];
            [annotation setSubtitle:@"Approximate job location"];
            [map addAnnotation:annotation];
            
            [map setShowsUserLocation:YES];
            [map setShowsBuildings:YES];
            [map setCenterCoordinate:coordinate zoomLevel:12 animated:NO];
            self.mapView = map;
        });
        
    }else if ([model objectForKey:@"action"] && [[model objectForKey:@"type"] isEqualToString:@"link"]){
        [detailLabel setText:[model objectForKey:@"subtitle"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cellActions setObject:[model objectForKey:@"action"] forKey:[NSString stringWithFormat:@"%ld:%ld",(long)indexPath.section,(long)indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cellActions objectForKey:[NSString stringWithFormat:@"%ld:%ld",(long)indexPath.section,(long)indexPath.row]]){
        void(^actionBlock)() = [cellActions objectForKey:[NSString stringWithFormat:@"%ld:%ld",(long)indexPath.section,(long)indexPath.row]];
        actionBlock();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    NSString *type = [[[[modelLayout objectAtIndex:indexPath.section]objectForKey:@"members"]objectAtIndex:indexPath.row] objectForKey:@"type"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:type];
    if (![type isEqualToString:@"text-based"]){
        height = cell.bounds.size.height;
    }else{
        NSDictionary *model = [[[modelLayout objectAtIndex:indexPath.section]objectForKey:@"members"]objectAtIndex:indexPath.row];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
        id input = [vacancyObject valueForKey:[model objectForKey:@"source"]];
        NSString *text=[NSString stringWithFormat:[model objectForKey:@"sourceFormat"] ? [model objectForKey:@"sourceFormat"]  : @"%@", input];
        [label setText:text];
        [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        label.numberOfLines = 0;
        CGSize size = [label sizeThatFits:CGSizeMake(cell.bounds.size.width, 400)];
        return size.height + 21;
    }
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[modelLayout objectAtIndex:section]objectForKey:@"title"];
}

#pragma mark Scroll View
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [MarqueeLabel controllerLabelsShouldLabelize:self];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [MarqueeLabel controllerLabelsShouldAnimate:self];
}


@end

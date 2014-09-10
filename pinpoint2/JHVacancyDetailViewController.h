//
//  JHVacancyDetailViewController.h
//  JobHappy
//
//  Created by Harry Jones on 08/02/2014.
//  Copyright (c) 2014 Harry Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHVacancy.h"

@interface JHVacancyDetailViewController : UITableViewController

@property (strong, nonatomic) JHVacancy *vacancyObject;
@property (nonatomic) NSArray *modelLayout;
@property (nonatomic) NSDictionary *cellTypes;

@property (nonatomic) NSMutableDictionary *cellActions;
@end

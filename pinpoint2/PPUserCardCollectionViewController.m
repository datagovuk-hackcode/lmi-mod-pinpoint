//
//  PPUserCardCollectionViewController.m
//  pinpoint2
//
//  Created by Philip Hardwick on 10/09/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPUserCardCollectionViewController.h"
#import "PPCardCollectionViewCell.h"

@interface PPUserCardCollectionViewController ()

@end

@implementation PPUserCardCollectionViewController

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
    self.cardService = [PPCardService sharedInstance];
    self.cards = [NSMutableArray arrayWithArray:[self.cardService getShownCardsForSocCode:self.socCode]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    cell.card = [self.cards objectAtIndex:indexPath.row];
    [cell configureCard];
    return cell;
}

- (void)cardDidBeginPanning:(PPCardCollectionViewCell *)cardCell {
    self.collectionView.scrollEnabled = NO;
}

- (void)cardDidEndPanning:(PPCardCollectionViewCell *)cardCell {
    self.collectionView.scrollEnabled = YES;
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

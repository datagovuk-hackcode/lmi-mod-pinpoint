//
//  PPCardCollectionViewController.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCardCollectionViewController.h"
#import "PPCardCollectionViewCell.h"
#import "PPCollectionViewFlowLayout.h"
#import "PPLoadingCollectionViewCell.h"

#define MIN_NUM_CARDS 5

@interface PPCardCollectionViewController () {
    NSTimer *getCardsTimer;
}

@end

@implementation PPCardCollectionViewController

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
    self.cards = [NSMutableArray arrayWithArray:[self.cardService getNumberOfCards:MIN_NUM_CARDS]];
    getCardsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getCardsFromCardServiceIfTheresNotEnough) userInfo:nil repeats:YES];
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
    cell.cardActionDelegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        PPLoadingCollectionViewCell *loadingView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"loadingCell" forIndexPath:indexPath];
        if (self.cards.count < MIN_NUM_CARDS) {
            [loadingView setIntoLoadingModeView];
        } else {
            [loadingView setIntoLoadedModeView];
        }
        reusableView = loadingView;
    }
    return reusableView;
}

- (void)cardWasSwipedLeft:(PPCardCollectionViewCell *)cardCell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cardCell];
    [self.collectionView performBatchUpdates:^{
        [self.cards removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL Finished){
        [cardCell.card handleDislike];
        [self getCardsFromCardServiceIfTheresNotEnough];
        [cardCell undoDelete];
    }];
}

- (void)cardWasSwipedRight:(PPCardCollectionViewCell *)cardCell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cardCell];
    [self.collectionView performBatchUpdates:^{
        [self.cards removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL Finished){
        [cardCell.card handleLike];
        [self getCardsFromCardServiceIfTheresNotEnough];
        [cardCell undoDelete];
    }];
}

- (void)getCardsFromCardServiceIfTheresNotEnough {
    if (self.cards.count < MIN_NUM_CARDS) {
        [self getCardsFromCardService:(MIN_NUM_CARDS - self.cards.count)];
    }
}

- (void)getCardsFromCardService:(int)numOfCards {
    int oldNumOfCards = self.cards.count;
    [self.cards addObjectsFromArray:[self.cardService getNumberOfCards:numOfCards]];
    int newNumOfCards = self.cards.count;
    [self.collectionView insertItemsAtIndexPaths:[self getIndexPathsOfNewlyInsertedCardsFromOldNumberOfCards:oldNumOfCards andNewNumOfCards:newNumOfCards]];
    if (self.cards.count >= MIN_NUM_CARDS) {
        [getCardsTimer invalidate];
        getCardsTimer = nil;
    }
}

- (NSArray *)getIndexPathsOfNewlyInsertedCardsFromOldNumberOfCards:(int)oldNumOfCards andNewNumOfCards:(int)newNumOfCards {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = oldNumOfCards; i < newNumOfCards; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (void)loadMoreCards:(id)sender {
    [self getCardsFromCardService:3];
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

//
//  PPCollectionViewFlowLayout.m
//  pinpoint2
//
//  Created by Philip Hardwick on 26/06/2014.
//  Copyright (c) 2014 Philip Hardwick. All rights reserved.
//

#import "PPCollectionViewFlowLayout.h"

@implementation PPCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        //self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(250.0f, 290.0f);
        self.sectionInset = UIEdgeInsetsMake(10, 0, 5, 0);
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if ((self.collectionViewContentSize.width <= attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) ||
            (self.collectionViewContentSize.height <= attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
            [newAttributes addObject:attribute];
        }
    }
    //NSLog(@"%d %d", newAttributes.count, attributes.count);
    NSArray *attrsList = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attrs in attrsList) {
        //NSLog(@"%f %f", attrs.frame.origin.x, attrs.frame.origin.y);
    }
    return newAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attrs = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    //NSLog(@"initialAttrs: %f %f atIndexPath: %d", attrs.frame.origin.x, attrs.frame.origin.y, itemIndexPath.item);
    
    return attrs;
}

@end

//
//  FlowLayout.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "FlowLayout.h"

#define ACTIVE_DISTANCE 500
#define ZOOM_FACTOR 0.5

@implementation FlowLayout
- (id)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(154, 200);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(120, 0, 120, 0);
        self.minimumLineSpacing = 50;
        self.minimumInteritemSpacing = 50;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMaxX(visibleRect) - attributes.center.x;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1+ZOOM_FACTOR * (1 - ABS(distance/ACTIVE_DISTANCE));
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}
@end

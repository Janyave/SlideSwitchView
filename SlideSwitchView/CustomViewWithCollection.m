//
//  CustonCollectionView.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 16/1/19.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "CustomViewWithCollection.h"
#import "CellViewCollectionViewCell.h"
#import "FlowLayout.h"

@implementation CustomViewWithCollection
static NSString * const reuseIdentifier = @"CollectionCell";
+ (id)viewFromNib
{
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"CustomViewWithCollection" owner:nil options:nil];
    return [viewArray firstObject];
}

- (void)awakeFromNib
{
    [self.collectionView registerClass:[CellViewCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    FlowLayout *layout = [[FlowLayout alloc] init];
    [self.collectionView setCollectionViewLayout: layout];
    
}

- (void)updateData:(NSArray *)aDataArray
{
    self.data = aDataArray;
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"ImageCell"];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];

    return cell;
}

@end

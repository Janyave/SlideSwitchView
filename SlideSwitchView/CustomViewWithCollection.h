//
//  CustonCollectionView.h
//  SlideSwitchView
//
//  Created by hzzhanyawei on 16/1/19.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewWithCollection : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *data;
+ (id)viewFromNib;
- (void)updateData:(NSArray *)aDataArray;
@end

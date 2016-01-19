//
//  CellViewCollectionViewCell.m
//  3DTouchDemo
//
//  Created by hzzhanyawei on 16/1/13.
//  Copyright © 2016年 hzzhanyawei. All rights reserved.
//

#import "CellViewCollectionViewCell.h"

@implementation CellViewCollectionViewCell
//- (id)init
//{
//    return [super init];
//}
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    return [super initWithCoder:aDecoder];
//}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:@"CellViewCollectionViewCell" owner:nil options:nil];
        self = [viewsArray objectAtIndex:0];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end

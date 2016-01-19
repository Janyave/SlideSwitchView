//
//  CustomView.h
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/18.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSArray *data;
+ (id)viewFromNib;
- (void)updateData:(NSArray *)aDataArray;
@end

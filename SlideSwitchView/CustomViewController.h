//
//  CustomViewController.h
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/16.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIView
+ (id)loadFromNib;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

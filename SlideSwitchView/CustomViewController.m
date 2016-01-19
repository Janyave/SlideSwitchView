//
//  CustomViewController.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/16.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

+ (id)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CustomViewController" owner:nil options:nil] firstObject];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  CustomView.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/18.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import "CustomView.h"

@interface CustomView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CustomView


+ (id)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (void)updateData:(NSArray *)aDataArray
{
    self.data = aDataArray;
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self.myTableView reloadData];
}

#pragma mark -- Delegate Func
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell  == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

@end

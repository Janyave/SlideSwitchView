//
//  ViewController.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/10.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import "ViewController.h"
#import "SlideSwitchView.h"

#import "CustomView.h"

@interface ViewController ()<SlideSwitchViewDelegate>
@property (nonatomic, strong) IBOutlet SlideSwitchView *switchView;
@property (nonatomic, strong) NSMutableArray *myData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createFakeData];
    //self.switchView = [[SlideSwitchView alloc] init];
    self.switchView.slideSwitchViewDelegate = self;
   [self.switchView buildUI];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFakeData
{
    self.myData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int j = 0; j < 50; j++)
        {
            NSString *str = [NSString stringWithFormat:@"第%d个表格***%d", i,j];
            [array addObject:str];
        }
        [self.myData addObject:array];
    }
}
#pragma mark -- SlideSwitchViewDelegate Func
- (NSUInteger)numberOfTab:(SlideSwitchView *)view
{
    return 100;
}

- (UIView *)slideSwitchViewGetReusedView:(SlideSwitchView *)view
{
    return [CustomView viewFromNib];
}

- (NSString *)slideSwitchView:(SlideSwitchView *)view titleOfTab:(NSUInteger)number
{
    return [NSString stringWithFormat:@"视图**%lu", number];
}

- (UIView *)slideSwitchView:(SlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    //如果是最近阅读或者离线阅读根据其位置number来获取特定的（非重用）cell
    
    CustomView *cell = (CustomView*)[view getReusedPage:number];
    if (cell == nil)
    {
        cell = [CustomView viewFromNib];
    }
    
    //填充cell的内容
    //模拟数据
    //判断data是否与cell现有data指向同一片内存，如果不是则加载数据。
    NSArray *arr = [self.myData objectAtIndex:number];
    if (arr != cell.data)
    {
        [cell updateData:arr];
    }
    else
    {
        NSLog(@"same data do not need refresh");
    }
    
    
    return cell;
}


- (void)slideSwitchView:(SlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SlideSwitchView *)view didselectTab:(NSUInteger)number
{
 
    
}

@end

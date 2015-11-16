//
//  ViewController.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/10.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import "ViewController.h"
#import "SlideSwitchView.h"
#import "CustomViewController.h"

@interface ViewController ()<SlideSwitchViewDelegate>
@property (nonatomic, strong) IBOutlet SlideSwitchView *switchView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark -- SlideSwitchViewDelegate Func
- (NSUInteger)numberOfTab:(SlideSwitchView *)view
{
    return 10;
}

- (UIViewController *)slideSwitchView:(SlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    //在这个地方做重用
    CustomViewController *viewController = [[CustomViewController alloc] initWithNibName:@"CustomViewController" bundle:nil];
    [viewController view];//要深刻理解controller和view
    viewController.titleLabel.text = [NSString stringWithFormat:@"视图**%lu", number];
    return viewController;
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

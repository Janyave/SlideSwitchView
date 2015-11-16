//
//  SlideSwitchView.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/10.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//
#define TopScrollViewY 64
#define TopScrollViewHeight 44
#define RootScrollViewY 108
#define RootScrollViewHeight 460
#define TopButtonMargin 16

#import "SlideSwitchView.h"
#import "CustomViewController.h"
@interface SlideSwitchView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;


@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIButton *rigthSideButton;

@property (nonatomic, assign) BOOL isRootScrollViewScrolling;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isUIBuild;

@end
@implementation SlideSwitchView

#pragma mark -- init && dealloc
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initValues];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initValues];
    }
    return self;
}
- (void)initValues
{
    
    [self initTopScrollView];
    [self initRootScrollView];
    
    _userContentOffsetX = 0.0;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    _viewArray = array;
    //[array release];
    
    _isUIBuild = NO;
    
    _userSelectedChannelID = 0;
}

- (void)initTopScrollView
{
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopScrollViewY, self.bounds.size.width, TopScrollViewHeight)];
    _topScrollView.tag = 10000;//不设置默认是0，会冲突。
    
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor grayColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    
}

- (void)initRootScrollView
{
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RootScrollViewY, self.bounds.size.width, RootScrollViewHeight)];
    
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;//多页显示
    _rootScrollView.userInteractionEnabled = YES;//允许用户事件
    _rootScrollView.bounces = NO;//边缘弹回
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;//布局
    
    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    [self addSubview:_rootScrollView];
}

//- (void)dealloc
//{
//    
//    [super dealloc];
//}

#pragma mark -- createUI

- (void)layoutSubviews
{
    if (self.isUIBuild)
    {
        //TODO顶部最右边更多的按键
        
        //self.topScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, TopScrollViewHeight);
        
        self.rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [self.viewArray count], RootScrollViewHeight);
        
        for (int i = 0; i < [self.viewArray count]; i++)
        {
            UIViewController *listVc = self.viewArray[i];
            listVc.view.frame = CGRectMake(0+self.rootScrollView.bounds.size.width * i, RootScrollViewY, self.rootScrollView.bounds.size.width, RootScrollViewHeight);
        }
        
        //滚动到选中的视图
        [self.rootScrollView setContentOffset:CGPointMake(self.userSelectedChannelID * self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[self.topScrollView viewWithTag: self.userSelectedChannelID];
        [self adjustScrollViewContentX:button];
        
    }
}
- (void)buildUI
{
    if (self.slideSwitchViewDelegate == nil)
    {
        return;
    }
    NSInteger number = 0;
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(numberOfTab:)])
    {
        number = [self.slideSwitchViewDelegate numberOfTab:self];
    }
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:viewOfTab:)])
    {
        for (int i = 0; i < number; i++)
        {
            CustomViewController *viewController = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
            [self.viewArray addObject:viewController];
            [self.rootScrollView addSubview:viewController.view];
        }
    }
    //默认选中第一个
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
    {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:self.userSelectedChannelID];
    }
    
    [self buildTopNamedButtons];
    
    [self setIsUIBuild:YES];
    
    [self setNeedsLayout];
}

- (void)buildTopNamedButtons
{
//    //顶部button区域的总长度
//    CGFloat totalWidthOfTopScrollView = TopButtonMargin;
    //每个button的起始区域
    CGFloat xOffset = TopButtonMargin;
    for(int i = 0; i < [self.viewArray count]; i++)
    {
        CustomViewController *viewController = self.viewArray[i];
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        //paragraph.alignment = NSLineBreakByTruncatingTail;//末尾截断
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName, [UIFont systemFontOfSize:17], NSParagraphStyleAttributeName, paragraph, nil];
        CGSize textSize = [viewController.titleLabel.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, TopScrollViewHeight) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        //totalWidthOfTopScrollView += TopButtonMargin + textSize.width;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(xOffset, 0, textSize.width, TopScrollViewHeight)];
        xOffset += TopButtonMargin + textSize.width;
        
        
        [button setTitle:viewController.titleLabel.text forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor greenColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        if (i == 0)
        {
            //设置第一个按键被按下UI
            button.selected = YES;
        }
        //设置按键UI
        button.tag = i;
        [button addTarget:self action:@selector(selectTopNamedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:button];
    }
    [self.topScrollView setContentSize:CGSizeMake(xOffset, TopScrollViewHeight)];
}
#pragma mark -- 处理tab按键事件
- (void)selectTopNamedButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    if (sender.tag != self.userSelectedChannelID)
    {
        UIButton *lastClickedButton = (UIButton *)[self.topScrollView viewWithTag:self.userSelectedChannelID];
        lastClickedButton.selected = NO;
        
        self.userSelectedChannelID = sender.tag;
    }
    if (!sender.isSelected)
    {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
        //设置被按下按键的UI
        }
         completion:^(BOOL finished) {
             if (!self.isRootScrollViewScrolling)
             {
                 [self.rootScrollView setContentOffset:CGPointMake(sender.tag*self.bounds.size.width, 0) animated:YES];
             }
             self.isRootScrollViewScrolling = NO;
             
             if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
             {
                 [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:sender.tag];
             }
         }];
    }
    
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.frame.origin.x - self.topScrollView.contentOffset.x > self.bounds.size.width - (TopButtonMargin + sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (self.topScrollView.bounds.size.width - (TopButtonMargin + sender.bounds.size.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - self.topScrollView.contentOffset.x < TopButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [self.topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - TopButtonMargin, 0)  animated:YES];
    }
}
#pragma mark -- 处理内容视图的滑动
//处理视图的滑动
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    if(self.rootScrollView.contentOffset.x <= 0)
    {
        if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)])
        {
            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
        }
    }
    else if(self.rootScrollView.contentOffset.x >= self.rootScrollView.contentSize.width - self.rootScrollView.bounds.size.width)
    {
        if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)])
        {
            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
        }
    }
}

#pragma mark -- scrollViewDelegate func

//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView)
    {
        self.userContentOffsetX  = scrollView.contentOffset.x;
    }
}
//滑动过程
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView)
    {
        if (self.userContentOffsetX < scrollView.contentOffset.x)
        {
            //向左滑动，设置tab跟随
        }
        else
        {
            //向右滑动
        }
    }
}
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView) {
        self.isRootScrollViewScrolling = YES;
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width;
        UIButton *button = (UIButton *)[self.topScrollView viewWithTag:tag];
        [self selectTopNamedButton:button];
    }
}
@end

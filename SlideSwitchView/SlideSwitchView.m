//
//  SlideSwitchView.m
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/10.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import "SlideSwitchView.h"
#import "CustomView.h"


#define TopScrollViewY 64
#define TopScrollViewHeight 44
#define RootScrollViewY 108
#define RootScrollViewHeight (self.bounds.size.height - RootScrollViewY)
#define TopButtonMargin 16
#define ViewFrameWidth [UIScreen mainScreen].bounds.size.width
#define ReusedPageNum 5


@interface SlideSwitchView() <UIScrollViewDelegate>
//内容显示ScrollView
@property (nonatomic, strong) UIScrollView *rootScrollView;
//标题显示ScrollView
@property (nonatomic, strong) UIScrollView *topScrollView;
//滑动前ScrollView的起始Offset.x
@property (nonatomic, assign) CGFloat userContentOffsetX;
//选中的标题ID
@property (nonatomic, assign) NSInteger userSelectedChannelID;
//所有标题的个数
@property (nonatomic, assign) NSInteger titleItemNum;
//最小复用View个数
@property (nonatomic, assign) NSInteger minPagerShowNum;
//可复用View的容器
@property (nonatomic, strong) NSMutableArray *pageArray;
//是否内容ScrollView滑动
@property (nonatomic, assign) BOOL isRootScrollViewScrolling;

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
    
    _userSelectedChannelID = 0;
    
    _pageArray = [[NSMutableArray alloc] init];
}

- (void)initTopScrollView
{
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopScrollViewY, self.bounds.size.width, TopScrollViewHeight)];
    _topScrollView.tag = 100000;//不设置默认是0，会冲突。
    
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
    _rootScrollView.bounces = YES;//边缘弹回
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;//布局
    
    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];

    [self addSubview:_rootScrollView];
}


#pragma mark -- createUI
//调整视图
- (void)adjustView
{
    self.rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * self.titleItemNum, RootScrollViewHeight);
    //滚动到选中的视图
    
    [self.rootScrollView setContentOffset:CGPointMake(self.userSelectedChannelID * self.bounds.size.width, 0) animated:NO];
    
    
    //调整顶部滚动视图选中按钮位置
    UIButton *button = (UIButton *)[self.topScrollView viewWithTag: self.userSelectedChannelID];
    [self adjustScrollViewContentX:button];
}

- (void)showPageInScrollView:(UIScrollView*) scrollView WithIdentifier:(NSInteger)aNum
{
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:viewOfTab:)])
    {
        UIView *viewCell = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:aNum];
        [viewCell setFrame:CGRectMake(scrollView.contentOffset.x, 0, self.rootScrollView.bounds.size.width, RootScrollViewHeight)];
    }
}
- (void)buildUI
{
    if (self.slideSwitchViewDelegate == nil)
    {
        return;
    }
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(numberOfTab:)])
    {
        self.titleItemNum = [self.slideSwitchViewDelegate numberOfTab:self];
        self.minPagerShowNum = MIN(self.titleItemNum, ReusedPageNum);
    }
    //创建可重用的view
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchViewGetReusedView:)])
    {
        
        for (int i = 0; i < self.minPagerShowNum; i++)
        {
            UIView *reusedView = [self.slideSwitchViewDelegate slideSwitchViewGetReusedView:self];
            reusedView.frame = CGRectMake(0+self.rootScrollView.bounds.size.width * i, 0, self.rootScrollView.bounds.size.width, RootScrollViewHeight);
            [self.pageArray addObject:reusedView];
            reusedView.tag = i;
            
            UIView *view = [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];//设置内容
            [self.rootScrollView addSubview:view];
        }
    }
   
    //默认选中第一个
    if ([self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
    {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:self.userSelectedChannelID];
    }
    
    [self buildTopNamedButtons];
 
    [self adjustView];
}

//创建标题按键
- (void)buildTopNamedButtons
{
    CGFloat xOffset = TopButtonMargin;
    for(int i = 0; i < self.titleItemNum; i++)
    {
       
        NSString *text = nil;
        if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:titleOfTab:)])
        {
            text = [self.slideSwitchViewDelegate slideSwitchView:self titleOfTab:i];
        }
        if (text == nil)
        {
            text = [NSString stringWithFormat:@"订阅源%d", i];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:text forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor greenColor]];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button sizeToFit];
        CGRect frame = button.bounds;
        [button setFrame:CGRectMake(xOffset, 0, frame.size.width, TopScrollViewHeight)];
        
        xOffset += TopButtonMargin + frame.size.width;
        
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

#pragma mark -- 重用View
- (UIView *)getReusedPage:(NSInteger)aNum
{
    NSInteger key = aNum % 5;
    if (key > ([self.pageArray count] - 1))
    {
        return nil;
    }
    UIView *view = [self.pageArray objectAtIndex:key];
    return view;
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
        
        if (!self.isRootScrollViewScrolling)
        {
            [self.rootScrollView scrollRectToVisible:CGRectMake(sender.tag * self.bounds.size.width,0,self.rootScrollView.bounds.size.width,self.rootScrollView.bounds.size.height) animated:NO];
            
            [self showPageInScrollView:self.rootScrollView WithIdentifier:sender.tag];
        }
        self.isRootScrollViewScrolling = NO;
        
        if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)])
        {
            [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:sender.tag];
        }
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
    if (scrollView == self.rootScrollView && self.userContentOffsetX != 0 )
    {
        if (self.userContentOffsetX < scrollView.contentOffset.x)
        {
            //向右滑动
            CGFloat scale = ABS(scrollView.contentOffset.x/ViewFrameWidth);
            NSInteger leftIndex = (NSInteger)scale;
            UIButton *zoomOutButton = (UIButton *)[self.topScrollView viewWithTag:leftIndex];
            UIButton *zoomInButtom = (UIButton *)[self.topScrollView viewWithTag:leftIndex + 1];
            [self animationScrollingScale:(scale - leftIndex) zoomOutButton:zoomOutButton zoomInButtom:zoomInButtom];
        }
        else
        {
            //向左滑动
            CGFloat scale = ABS(scrollView.contentOffset.x/ViewFrameWidth);
            NSInteger leftIndex = (NSInteger)scale;
            UIButton *zoomOutButton = (UIButton *)[self.topScrollView viewWithTag:leftIndex + 1];
            UIButton *zoomInButtom = (UIButton *)[self.topScrollView viewWithTag:leftIndex];
            [self animationScrollingScale:(leftIndex + 1 - scale) zoomOutButton:zoomOutButton zoomInButtom:zoomInButtom];

        }
    }
}
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.rootScrollView)//底部page滑动
    {
        //设置标题
        self.isRootScrollViewScrolling = YES;
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width;
        UIButton *button = (UIButton *)[self.topScrollView viewWithTag:tag];
        [self selectTopNamedButton:button];

        //设置View
        [self showPageInScrollView:scrollView WithIdentifier:tag];
        
        int fromTag = (int)self.userContentOffsetX/ViewFrameWidth;
        if (scrollView.contentOffset.x > self.userContentOffsetX)
        {
            for (int i = fromTag; i < tag; i++)
            {
                UIButton *changedButton = (UIButton *)[self.topScrollView viewWithTag:i];
                [self buttonBackStatus:changedButton];
            }
        }
        else
        {
            for (int i = fromTag; i > tag; i--)
            {
                UIButton *changedButton = (UIButton *)[self.topScrollView viewWithTag:i];
                [self buttonBackStatus:changedButton];
            }
        }

    }
    
}
#pragma makr -- 滑动过程动画
//item 状态恢复
- (void)buttonBackStatus:(UIButton *)aButton
{
//    aButton.transform = CGAffineTransformMakeScale(1, 1);
    aButton.titleLabel.textColor = [UIColor blackColor];
}
//滑动动画
- (void)animationScrollingScale:(CGFloat)scale zoomOutButton:(UIButton *)zoButton zoomInButtom:(UIButton *)ziButton
{
//    CGFloat ziKpi = scale * 0.1 + 1;//最终放大到1.1
//    CGFloat zoKpi = (0.1 - scale * 0.1) + 1;//最终缩小到1
//    ziButton.transform = CGAffineTransformMakeScale(ziKpi, ziKpi);
//    zoButton.transform = CGAffineTransformMakeScale(zoKpi, zoKpi);
    
    //red   255, 0, 0
    //black 0,   0, 0
//    CGFloat offsetR = 255 * scale;//255 -0
//    CGFloat offsetG = 0 * scale;//0-0
//    CGFloat offsetB = 0 * scale;//0-0
    [ziButton.titleLabel setTextColor:[UIColor colorWithRed:scale green:0 blue:0 alpha:1]];
    [zoButton.titleLabel setTextColor:[UIColor colorWithRed:(1 - scale) green:0 blue:0 alpha:1]];
}

@end

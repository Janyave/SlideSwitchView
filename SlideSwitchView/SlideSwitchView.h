//
//  SlideSwitchView.h
//  SlideSwitchView
//
//  Created by hzzhanyawei on 15/11/10.
//  Copyright © 2015年 hzzhanyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@protocol SlideSwitchViewDelegate;
@interface SlideSwitchView : UIView<UIScrollViewDelegate>
/**
 *  SlideSwitchView的委托
 */
@property (nonatomic, weak)  id<SlideSwitchViewDelegate> slideSwitchViewDelegate;

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI;

/*!
 * @method 查询并返回可重用的View
 * @abstract
 * @discussion
 * @param 可重用View标示
 * @result
 */
- (UIView *)getReusedPage:(NSInteger)aNum;



@end

@protocol SlideSwitchViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 * @abstract
 * @discussion
 * @param 本控件
 * @result tab个数
 */
- (NSUInteger)numberOfTab:(SlideSwitchView *)view;

/*!
 * @method 获取可重用的View
 * @abstract
 * @discussion
 * @param 本控件
 * @result 可重用的View
 */
- (UIView *)slideSwitchViewGetReusedView:(SlideSwitchView *)view;
/*!
 * @method 填充view内容
 * @abstract
 * @discussion
 * @param tab索引
 * @result View
 */
- (UIView *)slideSwitchView:(SlideSwitchView *)view viewOfTab:(NSUInteger)number;

/*!
 * @method 获取对应Tab的标题内容
 * @abstract
 * @discussion
 * @param tab索引
 * @result 标题内容
 */
- (NSString *)slideSwitchView:(SlideSwitchView *)view titleOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideSwitchView:(SlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideSwitchView:(SlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 * @abstract
 * @discussion
 * @param tab索引
 * @result
 */
- (void)slideSwitchView:(SlideSwitchView *)view didselectTab:(NSUInteger)number;

@end


//
//  OMSelectorView.h
//  OldMan
//
//  Created by fa on 16/10/10.
//  Copyright © 2016年 TCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

typedef struct {
//    按钮normal颜色
    UIColor *titleColor;
//    按钮select颜色
    UIColor *sliderColor;
//    按钮标题
    NSArray *titles;
} AFSelectorStyle;

@class AF_SelectorView;

@protocol AFSelectorViewDelegate <NSObject>

@optional

- (void)selectorView:(AF_SelectorView *)selectorView selectedIndex:(NSUInteger)index;

- (void)selectorView:(AF_SelectorView *)selectorView selectedIndex:(NSUInteger)index animation:(BOOL)animation;

@end

@interface AF_SelectorView : UIView

/**
 *  滑块间距
 */
@property (nonatomic, assign) CGFloat sliderMargin;

/**
 *  不显示竖分隔线
 */
@property (nonatomic, assign) BOOL isNotShowVerticalSeparLine;


@property (nonatomic, weak) id<AFSelectorViewDelegate>delegate;
/**
 *  按钮的width
 **/
@property (nonatomic, assign) CGFloat buttonWidth;

/**
 *  设置选项卡样式
 **/
- (void)segmentStyle:(AFSelectorStyle)style;
/**
 *  设置选中按钮
 */
- (void)selectButtonWithIndex:(NSUInteger)index;

/**
 *  设置选中按钮
 *
 *  @param index     按钮下标
 *  @param animation 是否有动画
 */
- (void)selectButtonWithIndex:(NSUInteger)index animation:(BOOL)animation;

/**
 *  根据百分比设置滑块和按钮
 */
- (void)selectButtonWithDistance:(CGFloat)distance;

@end

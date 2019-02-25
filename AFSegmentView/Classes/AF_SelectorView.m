//
//  OMSelectorView.m
//  OldMan
//
//  Created by fa on 16/10/10.
//  Copyright © 2016年 TCL. All rights reserved.
//
#import "AF_SelectorView.h"
#import "UIView+Extension.h"

#define separ_line_width 0.3
#define separ_margin 5
#define slider_default_margin 10
#define separ_gary_float 0.7
#define slider_height 2
#define button_tag 100
#define animate_duration 0.5

#define slider_color [UIColor colorWithRed:209/255.0 green:6/255.0 blue:6/255.0 alpha:1.0]

@interface AF_SelectorView()

@property (weak, nonatomic) UIButton *selectedBtn;

@property (weak, nonatomic) UIView *slider;

@property (assign, nonatomic) BOOL isSlide;//是否滑动

/**
 *  选项卡标题
 **/
@property (nonatomic, strong) NSArray *titles;
/**
 *  按钮的字体颜色
 **/
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  按钮底部滑条颜色
 **/
@property (nonatomic, strong) UIColor *sliderColor;

@end

@implementation AF_SelectorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSliderView];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self addSliderView];
    }
    return  self;
}
- (void)addSliderView
{
    UIView *slider = [[UIView alloc] init];
    slider.backgroundColor = slider_color;
    [self addSubview:slider];
    self.slider = slider;
    
    self.sliderMargin = slider_default_margin;//默认为10
}
- (void)setSliderMargin:(CGFloat)sliderMargin
{
    _sliderMargin = sliderMargin;
    
    self.slider.x = sliderMargin;
}
-(void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    self.slider.backgroundColor = _sliderColor;
}
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
}
- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    NSUInteger titlesCount = titles.count;
    if (titlesCount == 0) {
        return;
    }
}
-(void)segmentStyle:(AFSelectorStyle)style{
    self.titles = style.titles;
    self.titleColor = style.titleColor;
    self.sliderColor = style.sliderColor;
    
    if (self.titleColor == nil) {
        self.titleColor = [UIColor blackColor];
    }
    if (self.sliderColor == nil) {
        self.sliderColor = slider_color;
    }
    
    [self createButtons:self.titles];
}
- (void)createButtons:(NSArray *)titles{
    NSUInteger titlesCount = titles.count;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonWidth = self.width / titlesCount;
    CGFloat buttonHeight = self.height;
    for (NSUInteger i = 0; i < titlesCount; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + button_tag;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.sliderColor forState:UIControlStateDisabled];
        [button setTitleColor:self.sliderColor forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        [self addSubview:button];
        if (i == 0) {
            [self selectBtnClick:button];
        }
        buttonX += buttonWidth;
    }
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (void)selectBtnClick:(UIButton *)button
{
    [self selectBtnClick:button animation:YES];
}
- (void)selectBtnClick:(UIButton *)button animation:(BOOL)animation
{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    NSUInteger titlesCount = self.titles.count;
    
    NSUInteger index = button.tag - button_tag;
    
    CGFloat moveWidth = self.width / titlesCount;
    
    if (animation) {
        [UIView animateWithDuration:animate_duration animations:^{
            
            self.slider.x = index * moveWidth + self.sliderMargin;
            
        }];
    }else{
        self.slider.x = index * moveWidth + self.sliderMargin;
    }
    if ([self.delegate respondsToSelector:@selector(selectorView:selectedIndex:)]) {
        [self.delegate selectorView:self selectedIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(selectorView:selectedIndex:animation:)]) {
        [self.delegate selectorView:self selectedIndex:index animation:animation];
    }
}
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, separ_line_width);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetRGBStrokeColor(ctx, separ_gary_float, separ_gary_float, separ_gary_float, 1);
    
    CGFloat lineY = rect.size.height - separ_line_width;
    
    CGContextMoveToPoint(ctx, 0, lineY);
    
    CGContextAddLineToPoint(ctx, rect.size.width, lineY);
    
    CGContextStrokePath(ctx);
    
    if (self.isNotShowVerticalSeparLine) {
        return;
    }
    
    NSUInteger titlesCount = self.titles.count;
    if (titlesCount <= 1) {
        return;
    }
    CGFloat lineX = rect.size.width / titlesCount;
    
    for (NSUInteger i = 1;i < titlesCount; i++) {
        
        CGContextMoveToPoint(ctx, lineX * i, separ_margin);
        
        CGContextAddLineToPoint(ctx, lineX * i, rect.size.height - separ_margin);
        
        CGContextStrokePath(ctx);
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger titlesCount = self.titles.count;
    CGFloat sliderWidth = self.width / titlesCount - self.sliderMargin * 2;
    CGFloat sliderHeight = slider_height;
    CGFloat sliderX = isnan(self.slider.x) ? slider_default_margin : self.slider.x;
    CGFloat sliderY = self.height - sliderHeight;
    
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight);
}
- (void)selectButtonWithIndex:(NSUInteger)index
{
    [self selectButtonWithIndex:index animation:YES];
}
- (void)selectButtonWithIndex:(NSUInteger)index animation:(BOOL)animation
{
    UIButton *selectButton = (UIButton *)[self viewWithTag:index + button_tag];
    
    [self selectBtnClick:selectButton animation:animation];
}
- (void)selectButtonWithDistance:(CGFloat)distance
{
    UIButton *button = (UIButton *)[self viewWithTag:(NSInteger)distance + button_tag];
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    CGFloat moveWidth = self.width / self.titles.count;
    
    self.slider.x = moveWidth * distance + self.sliderMargin;
}

@end

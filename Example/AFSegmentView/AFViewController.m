//
//  AFViewController.m
//  AFSegmentView
//
//  Created by afhappy on 02/25/2019.
//  Copyright (c) 2019 afhappy. All rights reserved.
//

#import "AFViewController.h"
#import "AF_SelectorView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

@interface AFViewController ()<AFSelectorViewDelegate>

@property (nonatomic, strong) AF_SelectorView *segmentView;

@end

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.segmentView];
}
#pragma mark -  --创建segmentView
-(AF_SelectorView *)segmentView{
    if (!_segmentView) {
        
        _segmentView = [[AF_SelectorView alloc] initWithFrame:CGRectMake(0, 88, kScreenW, 46)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        /**
         * 设置选项卡样式以及标题等
         **/
        AFSelectorStyle style = {
            [UIColor blueColor],
            [UIColor redColor],
            @[@"测试一",@"测试二",@"测试三"],
        };
        [_segmentView segmentStyle:style];
        //    不显示竖分割线
        _segmentView.isNotShowVerticalSeparLine = YES;
        //        //    滑块间距---可以不设置，默认为10
        _segmentView.sliderMargin = 0;
        //    默认选中按钮
        [_segmentView selectButtonWithIndex:1];
        
        _segmentView.delegate = self;
    }
    return _segmentView;
}
#pragma mark -  --AFSelectorViewDelegate
-(void)selectorView:(AF_SelectorView *)selectorView selectedIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            NSLog(@"测试一");
            break;
        case 1:
            NSLog(@"测试二");
            break;
        case 2:
            NSLog(@"测试三");
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

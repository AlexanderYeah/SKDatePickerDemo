//
//  ViewController.m
//  SKDatePicker
//
//  Created by AY on 2017/12/1.
//  Copyright © 2017年 AY. All rights reserved.
//

#import "ViewController.h"
#import "MCDatePickerView.h"

@interface ViewController ()<MCDatePickerViewDelegate>
/** 日期选择控件 */
@property (nonatomic,strong)MCDatePickerView *monthView;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	UIButton *yearMonthDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[yearMonthDayBtn setTitle:@"年月日" forState:UIControlStateNormal];
	[yearMonthDayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[yearMonthDayBtn addTarget:self action:@selector(yearMonthDayBtnClick) forControlEvents:UIControlEventTouchUpInside];
	yearMonthDayBtn.frame = CGRectMake(100, 50, 100, 50);
	[self.view addSubview:yearMonthDayBtn];
	
	
	UIButton *yearMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[yearMonthBtn setTitle:@"年月" forState:UIControlStateNormal];
	[yearMonthBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[yearMonthBtn addTarget:self action:@selector(yearMonthBtnClick) forControlEvents:UIControlEventTouchUpInside];
	yearMonthBtn.frame = CGRectMake(100, 100, 100, 50);
	[self.view addSubview:yearMonthBtn];
	
	
	UIButton *yearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[yearBtn setTitle:@"年" forState:UIControlStateNormal];
	[yearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[yearBtn addTarget:self action:@selector(yearBtnClick) forControlEvents:UIControlEventTouchUpInside];
	yearBtn.frame = CGRectMake(100, 150, 100, 50);
	[self.view addSubview:yearBtn];
	
}

#pragma mark - 显示年
- (void)yearMonthDayBtnClick
{
	_monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:SKDateStyleTypeYearAndMonthAndDay];
	
    _monthView.delegate = self;
    [_monthView show];
	
}

#pragma mark - 显示年月
- (void)yearMonthBtnClick{

	_monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:SKDateStyleTypeYearAndMonth];
	
    _monthView.delegate = self;
    [_monthView show];

}
#pragma mark - 显示年
- (void)yearBtnClick{

	_monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:SKDateStyleTypeYear];
	
    _monthView.delegate = self;
    [_monthView show];
	
}

#pragma mark - 选择结果回调
- (void)didSelectDateResult:(NSString *)resultDate
{
	NSLog(@"用户选择----%@",resultDate);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end

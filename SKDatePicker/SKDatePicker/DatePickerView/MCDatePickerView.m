//
//  MCDatePickerView.m
//  MFCDatePackerView
//
//  Created by AY on 2017/5/23.
//  Copyright © 2017年 AY. All rights reserved.
//

static float ToolbarH  = 44;
static float PickerViewH  = 200;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MCDatePickerView.h"

@interface MCDatePickerView() <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong) UIPickerView *datePickerView;
@property (nonatomic ,strong) UIToolbar *toolBar;

/** 年 */
@property (nonatomic ,strong) NSMutableArray *month;
/** 月 */
@property (nonatomic ,strong) NSMutableArray *year;
/** 日 */
@property (nonatomic,strong)NSMutableArray *day;

/** 标记选中的年份 */
@property (nonatomic ,assign) NSInteger selectYearRow;
/** 标记选中的月份 */
@property (nonatomic ,assign) NSInteger selectMonthRow;
/** 标记选中的天 */
@property (nonatomic ,assign) NSInteger selectDayRow;


@property (nonatomic, assign) CGFloat toolViewY;//self的Y值
/** 日期控制器的类型 */
@property (nonatomic, assign ) SKDateStyleType type;


@property (nonatomic,strong)UIView *scView;
@end



@implementation MCDatePickerView

- (instancetype)initWithFrame:(CGRect)frame type:(SKDateStyleType)type{
    self.type = type;
    return  [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    return self;
}

#pragma mark - Delegate
 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == SKDateStyleTypeYear) {
        return 1;
    }else if (self.type == SKDateStyleTypeYearAndMonth){
		return 2;
	}else{
		return 3;
	}

}
/** 选中某一行 此处选中年份的时候要做去闰年判断 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectYearRow  = row;
    }else if(component == 1)
    {
        self.selectMonthRow = row;
		
		// 月份选择完 去重置第三列数据
		[self.datePickerView reloadComponent:2];
		
    }else{
		self.selectDayRow = row;
	}
}
/** 根据不同的列展示不同的数据 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	
	if (component == 0){
		return self.year.count;
	}else if (component == 1){
		return self.month.count;
	}else{
		// 1 3 5 7 8 10 12 显示31天
		NSString *currentMonStr = self.month[self.selectMonthRow];
		// 处理30天的这情况
		NSString *temStr = @"4-6-9-11";
		
		for (NSString *str in [temStr componentsSeparatedByString:@"-"]) {
			if ([currentMonStr isEqualToString:str]) {
				return self.day.count - 1;
			}
		}
		// 此处没有去判断闰年 直接返回29天 
		if ([currentMonStr isEqualToString:@"2"]) {
			return self.day.count - 2;

		}
		
//		// 处理2月的情况如果年数除以4，可以除尽。那么这一年的二月就有29天。如果除以4除不尽，那么这一年的二月就是28天。
//		NSString *curYearStr = self.year[self.selectYearRow];
//		
//		if ([currentMonStr isEqualToString:@"2"]) {
//					
//			if ([curYearStr intValue] % 4 == 0) {
//				// 是闰年 29 天
//				return self.day.count - 2;
//			}else{
//				return self.day.count - 3;
//			}
//		
//		}
		
		return self.day.count;
	}
	
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%@年",self.year[row]];
    }else if(component == 1)
    {
        return [NSString stringWithFormat:@"%@月",self.month[row]];
    }else{
		return [NSString stringWithFormat:@"%@日",self.day[row]];
	}
}

/**
    界面设置
 */
- (void)setupView
{
    [self addSubview:[self toolView]];
    
    UIPickerView *datePickerView = [[UIPickerView alloc] init];
    datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ToolbarH, SCREEN_W, PickerViewH)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.delegate   = self;
    datePickerView.dataSource = self;
    self.datePickerView = datePickerView;
    [self addSubview:datePickerView];
    
    self.toolViewY = SCREEN_H - (ToolbarH + PickerViewH);
    self.frame     = CGRectMake(0, SCREEN_H, SCREEN_W, (ToolbarH + PickerViewH));
    
    [self setCurrentDate];
}

/**
    设置默认时间->当前年月
 */
- (void)setCurrentDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *currentDate = [formatter stringFromDate:date];
    int year  = [[currentDate componentsSeparatedByString:@"-"][0] intValue];
    int month = [[currentDate componentsSeparatedByString:@"-"][1] intValue];

    NSInteger currentRow = year - [self.year[0] integerValue];
    
    [self.datePickerView selectRow:currentRow - 1 inComponent:0 animated:NO];
    if (self.type == SKDateStyleTypeYearAndMonth) {
        [self.datePickerView selectRow:0 inComponent:1 animated:NO];
    }
	[self.datePickerView selectRow:3 inComponent:1 animated:NO];
	self.selectYearRow = currentRow - 1;
	self.selectMonthRow = 3;
	
}



/**
 
 自定义tool view
 */

- (UIView *)toolView
{
    UIView *toolView = [[UIView alloc]init];
    toolView.frame =  CGRectMake(0, 0, SCREEN_W, ToolbarH);
    toolView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"   取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.text = NSTextAlignmentLeft;
    cancelBtn.frame = CGRectMake(20, 7, 70, 30);
    [toolView addSubview:cancelBtn];
    
    //
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"   确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor colorWithRed:23/255.0f green:171/255.0f blue:22/255.0f alpha:1] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    ensureBtn.titleLabel.text = NSTextAlignmentLeft;
    ensureBtn.frame = CGRectMake(SCREEN_W - 90, 7, 70, 30);
    [toolView addSubview:ensureBtn];
    
    
    UIView *sepview= [[UIView alloc]initWithFrame:CGRectMake(0, ToolbarH - 1, SCREEN_W, 1)];
    sepview.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    [toolView addSubview:sepview];
    
    
    return toolView;
    
}

/**
    工具栏
 */
- (UIToolbar *)toolBar
{
    if (!_toolBar)
    {

        _toolBar = [[UIToolbar alloc] init];
        _toolBar.frame = CGRectMake(0, 0, SCREEN_W, ToolbarH);
		_toolBar.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"   取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
        cancelItem.style = UIBarButtonItemStylePlain;
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确认   " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
		
        _toolBar.items = @[cancelItem, flexSpace, doneItem];
    }
    return _toolBar;
}

/**
    确定
 */
- (void)doneClick
{
    NSString *year  = self.year[self.selectYearRow];
    NSString *month = self.month[self.selectMonthRow];
    NSString *day = self.day[self.selectDayRow];
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    
    NSString *resultDate = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDateResult:)])
    {
        [self.delegate didSelectDateResult:resultDate];
    }
    
    [self remove];
}


/**
    移除PickerView
 */
- (void)remove
{
    
    [UIView animateWithDuration:0.35 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, PickerViewH + ToolbarH);
         
     } completion:^(BOOL finished)
     {
		[_scView removeFromSuperview];
		_scView = nil;
     }];
    
}

/**
    显示PickerView
 */
- (void)show
{
    UIView *screenView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    screenView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                 green:0/255.0
                                                  blue:0/255.0
                                                 alpha:0.5];
    screenView.tag             = 6221;
	_scView = screenView;
    [screenView addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow addSubview: screenView];
    
    [UIView animateWithDuration:0.35 animations:^
     {
         screenView.alpha = 1.0;
         self.frame = CGRectMake(0, self.toolViewY, SCREEN_W, PickerViewH + ToolbarH);
         
     } completion:^(BOOL finished)
     {
         
     }];
}




/**获取年份数据*/
- (NSMutableArray *)year
{
    if (!_year)
    {
        _year = [NSMutableArray array];
        
        for (int i = 1900; i < 2100; i++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%d",i];
            [_year addObject:yearStr];
        }
        
    }
    return _year;
}

/** 获取月份数据*/
- (NSMutableArray *)month
{
    if (!_month)
    {
        _month = [NSMutableArray array];
        
        for (int i = 1; i < 13; i++)
        {
            NSString *monthStr = [NSString stringWithFormat:@"%d",i];
            [_month addObject:monthStr];
        }
    }
    
    return _month;
}

/** 获取天的数据 */

- (NSMutableArray *)day
{
	if (!_day) {
		_day = [NSMutableArray array];
		
		for (int i = 1; i < 32; i ++) {
			NSString *dayStr = [NSString stringWithFormat:@"%d",i];
			[_day addObject:dayStr];
		}
	}
	
	return _day;
	
}


@end

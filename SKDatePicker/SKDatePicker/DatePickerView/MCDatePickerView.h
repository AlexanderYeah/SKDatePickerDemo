//
//  MCDatePickerView.h
//  MFCDatePackerView
//
//  Created by AY on 2017/5/23.
//  Copyright © 2017年 AY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SKDateStyleType) {
    SKDateStyleTypeYear = 0,//年
    SKDateStyleTypeYearAndMonth,//年月
    SKDateStyleTypeYearAndMonthAndDay, // 年月日
};


@protocol MCDatePickerViewDelegate <NSObject>

- (void)didSelectDateResult:(NSString *)resultDate;

@end

@interface MCDatePickerView : UIView

@property (nonatomic ,weak) id<MCDatePickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(SKDateStyleType)type;

/**
 显示PickerView
 */
- (void)show;

/**
 移除PickerView
 */
- (void)remove;

@end

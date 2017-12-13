//
//  STCircleView.h
//  STLoadAnimation
//
//  Created by st on 2017/12/13.
//  Copyright © 2017年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCircleView : UIView
/** 最大圆半径*/
@property (nonatomic, assign)CGFloat radius; // 默认是140

/*! 默认中心实心圆半径 */
@property (nonatomic, assign)CGFloat centerRadius; // 默认是8

/** 间隔比例*/
@property (nonatomic, assign)CGFloat marginSacle; // 0.0 ~ 1.0

@end

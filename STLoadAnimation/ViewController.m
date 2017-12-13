//
//  ViewController.m
//  STLoadAnimation
//
//  Created by st on 2017/12/13.
//  Copyright © 2017年 st. All rights reserved.
//

#import "ViewController.h"
#import "STCircleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    STCircleView *circleView = [[STCircleView alloc]init];
    circleView.frame = CGRectMake(30, 150, self.view.bounds.size.width-60, self.view.bounds.size.width-60);
    circleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:circleView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

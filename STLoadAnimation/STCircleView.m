//
//  STCircleView.m
//  STLoadAnimation
//
//  Created by st on 2017/12/13.
//  Copyright © 2017年 st. All rights reserved.
//

#import "STCircleView.h"
/*! 默认最大圆半径 */
static int const kDefaultRadius = 140;
/*! 默认圈数 */
static int const kDefaultCircleNumber = 3;
/*! 默认中心实心圆半径 */
static int const kDefaultCenterRadius = 8;

/*! 默认间隔比例 */
static CGFloat const kDefaultMagrinSacle = 0.4; //0 ~ 1

@interface STCircleView()<CAAnimationDelegate>{
    CAShapeLayer * arcLayer1;//圆环背景
    CAShapeLayer * arcLayer2;
    CAShapeLayer * arcLayer3;
    CAShapeLayer * trackLayer1;//绘制三条圆弧
    CAShapeLayer * trackLayer2;
    CAShapeLayer * trackLayer3;
    CGContextRef context;//中心实心圆
}
@property(nonatomic,strong) CABasicAnimation * anima1; /**< 圆弧绘制动画 */
@property(nonatomic,strong) CABasicAnimation * anima2; /**< 圆弧绘制动画 */
@property(nonatomic,strong) CABasicAnimation * anima3; /**< 圆弧绘制动画 */
@property(nonatomic,assign) CGFloat magrin; /**<圆间距 */
@property(nonatomic,assign) BOOL isAgainDraw; /**<是否重绘 */
@property(nonatomic,assign) CGFloat sectionRadius; /**<每个圆圈的半径 */
@end


@implementation STCircleView

- (void)drawRect:(CGRect)rect {
    
    //重绘设置上下文红色背景
    if (_isAgainDraw) {
        /*! 画圆*/
        context = UIGraphicsGetCurrentContext();
        UIColor *aColor =  [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, 1.0);//线的宽度
        CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5,kDefaultCenterRadius+self.magrin, 0, 2*M_PI, 0); //添加一个圆
        [aColor setFill];
        [aColor setStroke];
        //显示一个实心圆
        CGContextFillPath(context);
        
        return;
    }
    //开始绘制圆弧
    [self drawRadius];
}

// 画许多圆弧
- (void)drawRadius{
    
    // 默认的圈数
    NSUInteger sectionsNum = kDefaultCircleNumber;
    
    // 圆圈半径
    CGFloat radius = kDefaultRadius;
    if (self.radius) {
        radius = self.radius;
    }
    
    // 中间半径
    CGFloat centerRadius = kDefaultCenterRadius;
    if (self.centerRadius) {
        centerRadius = self.centerRadius;
    }
    
    // 画多个圆圈
    // 中心距离最外圈的距离
    CGFloat detaRadius = (radius - centerRadius);
    
    //每个圆圈的半径
    CGFloat sectionRadius = centerRadius;
    
    //间隔比例
    CGFloat magrinSacle = kDefaultMagrinSacle;
    
    if (self.marginSacle) {
        if (self.marginSacle > 1.0) {
            magrinSacle = 1.0;
        } else if (self.marginSacle < 0.0){
            magrinSacle = 0.0;
        } else{
            magrinSacle = self.marginSacle;
        }
        
    }
    
    CGFloat magrin = detaRadius / sectionsNum * magrinSacle;
    self.magrin = magrin;
    for (int i = 1; i < sectionsNum + 1; i++) {
        
        // 每个圆圈半径
        sectionRadius += magrin;
        
        //创建背景圆环
        CAShapeLayer *trackLayer = [CAShapeLayer layer];
        trackLayer.frame = self.bounds;
        //清空填充色
        trackLayer.fillColor = [UIColor clearColor].CGColor;
        //设置画笔颜色 即圆环背景色
        if (i== 1) {
            trackLayer.strokeColor =  [UIColor colorWithRed:244/255.0 green:164/255.0 blue:165/255.0 alpha:1].CGColor;
        }else if (i == 2){
            trackLayer.strokeColor =  [UIColor colorWithRed:242/255.0 green:120/255.0 blue:125/255.0 alpha:1].CGColor;
        }else if (i == 3){
            trackLayer.strokeColor =  [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        }
        trackLayer.lineWidth = magrin;
        //设置画笔路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:sectionRadius startAngle:- M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
        //path 决定layer将被渲染成何种形状
        trackLayer.path = path.CGPath;
        [self.layer addSublayer:trackLayer];
        if (i == 1) {
            trackLayer1 =trackLayer;
        }else if (i == 2){
            trackLayer2 =trackLayer;
        }else if (i == 3){
            trackLayer3 =trackLayer;
        }
        
        
    }
    
    /*! 画圆*/
    context = UIGraphicsGetCurrentContext();
    UIColor *aColor = [UIColor colorWithRed:246/255.0 green:193/255.0  blue:194/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5, centerRadius+magrin, 0, 2*M_PI, 0); //添加一个圆
    [aColor setFill];
    [aColor setStroke];
    //显示上下文 显示一个实心圆
    CGContextFillPath(context);
    
    
    sectionRadius = centerRadius;
    for (int i = 1; i < sectionsNum + 1; i++) {
        //为绘制准备
        if (i == 1) {
            sectionRadius += magrin/2;
        }else{
            sectionRadius += magrin;
        }
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:sectionRadius startAngle:- M_PI_2- M_PI/3 endAngle:-M_PI_2 + M_PI * 2 - M_PI/3 clockwise:YES];
        
        CAShapeLayer * arcLayer = [CAShapeLayer layer];
        arcLayer.path = path2.CGPath;
        arcLayer.fillColor = [UIColor clearColor].CGColor;
        arcLayer.strokeColor = [UIColor whiteColor].CGColor;
        arcLayer.lineWidth = 3;
        arcLayer.lineCap = @"round";
        arcLayer.frame = self.bounds;
        if(i == 1){
            arcLayer1 = arcLayer;
            [self.layer addSublayer:arcLayer1];
        }else if (i == 2){
            arcLayer2 = arcLayer;
            [self.layer addSublayer:arcLayer2];
        }else if (i == 3){
            arcLayer3 = arcLayer;
            [self.layer addSublayer:arcLayer3];
        }
        
        
        CABasicAnimation * anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        anima.fromValue = [NSNumber numberWithFloat:0.f];
        anima.toValue = [NSNumber numberWithFloat:0.3];
        anima.duration = 2.0f;
        anima.autoreverses = NO;
        anima.removedOnCompletion = NO;
        anima.fillMode =kCAFillModeForwards;
        anima.repeatCount = 1;
        
        if (i == 1) {
            self.anima1 = anima;
            [arcLayer1 addAnimation:self.anima1 forKey:@"strokeEndAniamtion1"];
        }else if(i == 2){
            self.anima2 = anima;
            [arcLayer2 addAnimation:self.anima2 forKey:@"strokeEndAniamtion2"];
        }else if (i == 3){
            self.anima3 = anima;
            [arcLayer3 addAnimation:self.anima3 forKey:@"strokeEndAniamtion3"];
        }
        
        CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anima3.toValue = [NSNumber numberWithFloat:-M_PI*2];
        if (i == 1||i==3) {
            anima3.toValue = [NSNumber numberWithFloat:M_PI*2];
        }
        anima3.duration = 2.5f;
        anima3.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anima3.removedOnCompletion= NO;
        anima3.delegate = self;
        
        if (i == 1) {
            [arcLayer1 addAnimation:anima3 forKey:@"rotaionAniamtion"];
        }else if ( i == 2){
            [arcLayer2 addAnimation:anima3 forKey:@"rotaionAniamtion"];
        }else if ( i == 3){
            [arcLayer3 addAnimation:anima3 forKey:@"rotaionAniamtion"];
        }
        
        
    }
    
}
#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart%@",arcLayer3.animationKeys);
    
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if (anim==[arcLayer3 animationForKey:@"rotaionAniamtion"]) {
        
        CABasicAnimation* rotationAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.duration = 1.0;
        rotationAnimation.removedOnCompletion= NO;
        rotationAnimation.delegate = self;
        rotationAnimation.repeatCount = 1;
        for (int i = 1 ; i< 4; i++) {
            rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI*2];
            if (i == 1||i==3) {
                rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
            }
            if (i == 1) {
                [arcLayer1 addAnimation:rotationAnimation forKey:@"rotaionAniamtionst"];
            }else if ( i == 2){
                [arcLayer2 addAnimation:rotationAnimation forKey:@"rotaionAniamtionst"];
            }else if ( i == 3){
                [arcLayer3 addAnimation:rotationAnimation forKey:@"rotaionAniamtionst"];
            }
        }
        
    }
    
    if (anim==[arcLayer3 animationForKey:@"rotaionAniamtionst"]) {
        self.anima1.fromValue = [NSNumber numberWithFloat:0.3f];
        self.anima1.toValue = [NSNumber numberWithFloat:0.01f];
        self.anima1.duration = 2.0f;
        self.anima1.autoreverses = NO;
        self.anima1.removedOnCompletion = NO;
        self.anima1.fillMode =kCAFillModeForwards;
        self.anima1.repeatCount = 1;
        [arcLayer1 addAnimation:self.anima1 forKey:@"strokeEndAniamtion1"];
        
        self.anima2.fromValue = [NSNumber numberWithFloat:0.3f];
        self.anima2.toValue = [NSNumber numberWithFloat:0.005f];
        self.anima2.duration = 2.0f;
        self.anima2.autoreverses = NO;
        self.anima2.removedOnCompletion = NO;
        self.anima2.fillMode =kCAFillModeForwards;
        self.anima2.repeatCount = 1;
        [arcLayer2 addAnimation:self.anima2 forKey:@"strokeEndAniamtion2"];
        
        self.anima3.fromValue = [NSNumber numberWithFloat:0.3f];
        self.anima3.toValue = [NSNumber numberWithFloat:0.005f];
        self.anima3.duration = 2.0f;
        self.anima3.autoreverses = NO;
        self.anima3.removedOnCompletion = NO;
        self.anima3.fillMode =kCAFillModeForwards;
        self.anima3.repeatCount = 1;
        [arcLayer3 addAnimation:self.anima3 forKey:@"strokeEndAniamtion3"];
        
        CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anima3.toValue = [NSNumber numberWithFloat:M_PI/3-0.1];
        anima3.duration = 2.0f;
        anima3.repeatCount = 1;
        anima3.autoreverses = NO;
        anima3.removedOnCompletion = NO;
        anima3.fillMode =kCAFillModeForwards;
        anima3.delegate = self;
        [arcLayer1 addAnimation:anima3 forKey:@"rotaionAniamtion1"];
        [arcLayer2 addAnimation:anima3 forKey:@"rotaionAniamtion2"];
        [arcLayer3 addAnimation:anima3 forKey:@"rotaionAniamtion3"];
        
    }
    //
    if (anim==[arcLayer1 animationForKey:@"rotaionAniamtion1"]){
        /* 移动 */
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = 2.5;
        animation.repeatCount = 1;
        animation.removedOnCompletion= NO;
        animation.autoreverses = NO;
        animation.fillMode =kCAFillModeForwards;
        animation.delegate = self;
        // 起始帧和终了帧的设定
        //        animation.fromValue = [NSValue valueWithCGPoint:arcLayer1.position]; // 起始帧
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0+ 5*kDefaultCenterRadius)]; // 终了帧
        [arcLayer1 addAnimation:animation forKey:@"move-layer1"];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0+ 5*kDefaultCenterRadius+self.magrin)];
        [arcLayer2 addAnimation:animation forKey:@"move-layer2"];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0+ 5*kDefaultCenterRadius+self.magrin*2)];
        [arcLayer3 addAnimation:animation forKey:@"move-layer3"];
        
        
        trackLayer1.strokeColor  =  [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        trackLayer1.fillColor = [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        trackLayer2.strokeColor  =  [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        trackLayer2.fillColor  = [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        trackLayer3.fillColor = [UIColor colorWithRed:237/255.0 green:57/255.0 blue:57/255.0 alpha:1].CGColor;
        
        if (!self.isAgainDraw) {
            self.isAgainDraw = YES;
            [self setNeedsDisplay];
        }
    }
    
    if (anim==[arcLayer3 animationForKey:@"move-layer3"]){
        
        _sectionRadius = kDefaultCenterRadius;
        //        for (int i = 1; i < 3 + 1; i++) {
        
        //        底部大圆点成型
        //        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0+self.magrin/2+2) radius:1 startAngle:- M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
        //        CAShapeLayer * arcLayer = [CAShapeLayer layer];
        //        arcLayer.path = path2.CGPath;
        //        arcLayer.fillColor = [UIColor clearColor].CGColor;
        //        arcLayer.strokeColor = [UIColor whiteColor].CGColor;
        //        //        arcLayer.strokeStart = -1;
        //        //        arcLayer.strokeEnd = 1;
        //        arcLayer.lineWidth = 4;
        //        arcLayer.frame = self.bounds;
        //        [self.layer addSublayer:arcLayer];
        //
        //        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //        animation.duration = 0.5; //
        //        animation.repeatCount = 1; //
        //        animation.autoreverses = NO; //
        //        animation.removedOnCompletion = NO;
        //        animation.fillMode =kCAFillModeForwards;
        //        // 缩放倍数
        //        animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
        //        animation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
        //        [arcLayer addAnimation:animation forKey:@"scale-layer"];
        //
        //        }
        
        //绘制最后三条圆弧
        [self goShape];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goShape];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self goShape];//这里执行完毕可以移除相关动画或sublayer或当前整个view
            });
            
        });
        
        
    }
    
}

- (void)goShape{
    _sectionRadius += self.magrin;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0,self.frame.size.height/2.0+ 5*kDefaultCenterRadius - self.magrin/2) radius:_sectionRadius startAngle:- M_PI_2+ M_PI/6+M_PI/36 endAngle:-M_PI_2 + M_PI * 2 + M_PI/6+M_PI/36 clockwise:YES];
    CAShapeLayer * arcLayer = [CAShapeLayer layer];
    arcLayer.path = path2.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = [UIColor whiteColor].CGColor;
    arcLayer.strokeStart = 0.8;
    arcLayer.strokeEnd = 1;
    arcLayer.lineWidth = 3;
    arcLayer.lineCap = @"round";
    arcLayer.frame = self.bounds;
    [self.layer addSublayer:arcLayer];
    
}
@end

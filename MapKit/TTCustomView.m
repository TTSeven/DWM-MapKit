//
//  TTCustomView.m
//  MapKit
//
//  Created by 业余班 on 16/4/11.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import "TTCustomView.h"

@implementation TTCustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
    }return self;
}


//在此 自定义绘画和动画
- (void)drawRect:(CGRect)rect {
    //画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 252/255.0, 106/255.0, 8/255.0, 1.0);//画笔颜色
    CGContextSetLineWidth(context, 1.0);//线宽
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。  
    CGContextAddArc(context, 100, 50, 15, 0,2*3.141592658 , 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke);
}


@end

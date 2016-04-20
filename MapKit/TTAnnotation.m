//
//  TTAnnotation.m
//  MapKit
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import "TTAnnotation.h"

@implementation TTAnnotation



+ (MKAnnotationView *)setViewWithMapView:(MKMapView *)mapView andAnnotation:(id <MKAnnotation>)annotation{
    
    TTAnnotation *anno = (TTAnnotation *)annotation;
    static NSString *identifier1 = @"Annotation";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier1];
    if (!view) {
        view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier1];
    }
    
    view.annotation = annotation;

    //图标
    view.image = anno.icon;
    
    //可弹出视图 此处设为 no 即可只显示自定义的视图而不会显示详情视图 yes 则两个视图都显示
    view.canShowCallout = NO;//不弹出详情视图 但是可点击
    
    //上面设置了no这里的代码就相当与没用了 显示不出来
    UIImage *leftImage = [UIImage imageNamed:@"anno2.png"];
    UIImage *rightImage = [UIImage imageNamed:@"anno3.png"];
    UIImageView *leftView = [[UIImageView alloc]initWithImage:leftImage];
    UIImageView *rightView = [[UIImageView alloc]initWithImage:rightImage];
    
    leftView.bounds = CGRectMake(0, 0, 50, 50);
    rightView.bounds = CGRectMake(0, 0, 50, 50);
    view.leftCalloutAccessoryView = leftView;
    view.rightCalloutAccessoryView = rightView;
    
    return view;
}

@end

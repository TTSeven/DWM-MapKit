//
//  TTCalloutAnnotation.m
//  MapKit
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import "TTCalloutAnnotation.h"

@implementation TTCalloutAnnotation

+ (MKAnnotationView *)viewWithMapView:(MKMapView *)mapView addAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"TTCalloutAnnotation";
    MKAnnotationView *calloutView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!calloutView) {
        calloutView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        
    }
    
    calloutView.annotation = annotation;
//    大头针弹出视图偏移量
    calloutView.centerOffset = CGPointMake(-50, -90);
    calloutView.dragState = 0;
    
    return calloutView;
}


@end

//
//  TTAnnotation.h
//  MapKit
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


/** 额外属性用于自定义 */
@property(nonatomic,strong)UIImage *icon;

/** 包装大头针视图 */
+ (MKAnnotationView *)setViewWithMapView:(MKMapView *)mapView andAnnotation:(id <MKAnnotation>)annotation;

@end

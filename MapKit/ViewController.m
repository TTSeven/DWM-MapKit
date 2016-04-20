//
//  ViewController.m
//  MapKit
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 xiaoM. All rights reserved.
//

#import "ViewController.h"
#import "TTAnnotation.h"
#import "TTCalloutAnnotation.h"
#import "TTDetialViewController.h"
#import "TTCustomView.h"

@interface ViewController ()<MKMapViewDelegate,UIPopoverPresentationControllerDelegate>
/** 地图对象 */
@property(nonatomic,strong)MKMapView *mapView;
/** 地图管理对象 */
@property(nonatomic,strong)CLLocationManager *manager;
/** 地理编码对象 */
@property(nonatomic,strong)CLGeocoder *geocoder;

/** 存位置数组 */
@property(nonatomic,strong)NSMutableArray *locationArray;

/** 存原来的路线 */
@property(nonatomic,strong)MKPolyline *polyline;

/** 存用户现在的位置 */
@property(nonatomic,strong)MKUserLocation *userlocation;

@property(nonatomic,strong)UIView *subView1;

@end

@implementation ViewController


#pragma mark - 懒加载
-(NSMutableArray *)locationArray{
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }return _locationArray;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
        
    }return _geocoder;
    
}

-(CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        //允许定位用户位置信息 info.plist文件中添加 key
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
            [_manager requestWhenInUseAuthorization];
        }else{
            [_manager startUpdatingLocation];
        }
        
    }return _manager;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //准确度
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = 10;

    //初始化 mapview
    [self initMapView];
    //添加按钮
    [self setBtn];
    
    
}
#pragma MARK 地理编码初始化开始/终点 两点间的线
- (void)drawLine{
    
    //导航请求
    MKDirectionsRequest *req = [[MKDirectionsRequest alloc]init];
    //步行 还是汽车
    req.transportType = MKDirectionsTransportTypeTransit;
    
    //起点--终点
    [self.geocoder geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *startPlace = [placemarks firstObject];
        
        [self.geocoder geocodeAddressString:@"南宁" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *toPlace = [placemarks firstObject];
            
            [self getRouteWithBeginPL:startPlace toPL:toPlace];
        }];
    }];

}

#pragma mark - 跟踪用户位置的画线
- (void)drawUserlocation{

    NSInteger count = self.locationArray.count;
    MKMapPoint *points = malloc(sizeof(MKMapPoint)*count);
    
    [self.locationArray enumerateObjectsUsingBlock:^(CLLocation *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MKMapPoint point = MKMapPointForCoordinate(obj.coordinate);
        points[idx] = point;
    }];
    //移除原有的线 减少内存
    if (self.polyline) {
        [self.mapView removeOverlay:self.polyline];
    }
    self.polyline = [MKPolyline polylineWithPoints:points count:count];
    [self.mapView addOverlay:self.polyline];
    
    
    free(points);
}

- (void)getRouteWithBeginPL:(CLPlacemark *)startPlace toPL:(CLPlacemark *)toPlace{
    //设置请求路线
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    MKPlacemark *startPL = [[MKPlacemark alloc]initWithPlacemark:startPlace];
    MKPlacemark *toPL = [[MKPlacemark alloc]initWithPlacemark:toPlace];
    MKMapItem *souceItem = [[MKMapItem alloc]initWithPlacemark:startPL];
    MKMapItem *destItem = [[MKMapItem alloc]initWithPlacemark:toPL];
    
    request.source = souceItem;
    request.destination = destItem;
    
    //创建请求导航路线对象
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    //发起请求 获取导航路线
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%s",__FUNCTION__);
        }else{
           
            [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self.mapView addOverlay:obj.polyline];
                //代理方法中 设置线的颜色宽度等
            }];
        }
        
    }];
}

- (void) setBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-50, 100, 30)];
    [btn setTitle:@"添加大头针" forState:0];
    btn.backgroundColor = [UIColor darkGrayColor];
    [btn addTarget:self action:@selector(addAnnntation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height-250, 100, 30)];
    [btn1 setTitle:@"南宁-广州" forState:0];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(drawLine) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:btn1];
}
/** 添加大头针 */
- (void)addAnnntation{
    
    TTAnnotation *anno = [TTAnnotation new];
    anno.title = @"小明哥";
    anno.subtitle = @"广州小明哥";
    //控制大头针显示的位置
    
    CLLocationDegrees latttude = self.userlocation.location.coordinate.latitude;
    CLLocationDegrees longitude = self.userlocation.location.coordinate.longitude;
    CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(latttude, longitude);
    anno.coordinate = location2D;
    anno.icon = [UIImage imageNamed:@"anno1.png"];
    
    [self.mapView addAnnotation:anno];
}

- (void)initMapView{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    
    //创建MKMitView
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(x,y, w, h)];
    //设置地图类型  卫星
    mapView.mapType = MKMapTypeStandard;
    
    mapView.delegate = self;
    //跟踪位置模式（带方向）
    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
}

#pragma mark - MKMapViewDelegate
/** 定位到用户位置 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"经度:%lf  纬度:%lf",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    userLocation.title = @"广州";
    userLocation.subtitle = @"天河";
   
    self.userlocation = userLocation;
    
    [self.locationArray addObject:userLocation.location];
    
    [self drawUserlocation];
}

/** 地图显示区域改变 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
  //打开会有画面一会大一会小的问题
    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span);
//    self.mapView.region = region;
   
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[TTAnnotation class]]) {

        return [TTAnnotation setViewWithMapView:mapView andAnnotation:annotation];
    
    }else if ([annotation isKindOfClass:[TTCalloutAnnotation class]]){
        
        return [TTCalloutAnnotation viewWithMapView:mapView addAnnotation:annotation];
        
    }
    //使用默认
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[TTAnnotation class]]) {
        
        TTAnnotation *annotation = view.annotation;
        //点击一个大头针时移除其他弹出详情视图
        [self removeCalloutAnnotation];
        
        //添加详情大头针 此处为了在详情视图位置显示自定义视图
        TTCalloutAnnotation *callout = [[TTCalloutAnnotation alloc] init];
        callout.icon = annotation.icon;
        callout.title = annotation.title;
        callout.subtitle = annotation.subtitle;
        callout.coordinate = annotation.coordinate;
        [self.mapView addAnnotation:callout];
        
        //推出自定义视图作为详情视图
        TTDetialViewController *detialVC = [[TTDetialViewController alloc]init];
        detialVC.modalPresentationStyle = UIModalPresentationPopover;
        detialVC.popoverPresentationController.sourceView = view;
        detialVC.popoverPresentationController.sourceRect = view.bounds;
        detialVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        detialVC.popoverPresentationController.delegate = self;
        
        [self presentViewController:detialVC animated:YES completion:nil];
    }
}
/** 不选择的时候触发 */
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCalloutAnnotation];
}
#pragma mark - UIPopoverPresentationControllerDelegate 不实现此方法 则弹出视图的大小就不会改变,会造成满屏的效果
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

#pragma mark 移除所有详情大头针
- (void)removeCalloutAnnotation{
    
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[TTCalloutAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}


#pragma mark - 画路线相关代理方法
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    renderer.lineWidth = 3;
    renderer.strokeColor = [UIColor greenColor];
    
    return renderer;
}


#pragma mark - 画圈圈
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"X:%f  Y:%f",point.x,point.y);
    [self addSubViewAtPoint:point];
}

- (void)addSubViewAtPoint:(CGPoint)point{
    
    self.subView1 = [[TTCustomView alloc]initWithFrame:CGRectMake(point.x-98, point.y-48, 320, self.view.frame.size.height)];;
    self.subView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.subView1];
    
}


@end

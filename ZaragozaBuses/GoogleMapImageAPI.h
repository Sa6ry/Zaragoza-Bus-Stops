//
//  GoogleMapImageAPI.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/23/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"
#import <CoreLocation/CoreLocation.h>

@interface GoogleMapImageAPI : WebBaseAPI

@property (nonatomic,readonly) UIImage*  _Nullable image;


- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithLocation: instead.")));

- (instancetype _Nullable) initWithCoordinate:( CLLocationCoordinate2D ) coordiante;

@end

//
//  ReviewAPI.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"
#import "BusStop.h"
#import "BusStopComingBus.h"



@interface BusStopListAPI : WebBaseAPI

@property (nonatomic,readonly) NSArray<BusStop*> * _Nonnull busStops;

@end

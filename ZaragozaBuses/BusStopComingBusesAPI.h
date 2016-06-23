//
//  BusStopComingBusesAPI.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/20/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"
#import "BusStopComingBus.h"

@interface BusStopComingBusesAPI : WebBaseAPI

@property (nonatomic,readonly) NSArray<BusStopComingBus*> * _Nonnull sortedComingBuses;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithBusStopID: instead.")));

- (instancetype _Nullable) initWithBusStopID:(NSInteger) busStopID;

@end

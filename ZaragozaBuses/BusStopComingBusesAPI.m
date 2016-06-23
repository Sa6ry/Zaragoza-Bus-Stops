//
//  BusStopComingBusesAPI.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/20/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "BusStopComingBusesAPI.h"

@implementation BusStopComingBusesAPI

@synthesize sortedComingBuses = _sortedComingBuses;

- (instancetype _Nullable) initWithBusStopID:(NSInteger) busStopID
{
    self = [super init];
    if(self) {
        
        self.jsonEndPoint = [@"http://api.dndzgz.com/services/bus/" stringByAppendingFormat:@"%ld",(long)busStopID];
        
    }
    return self;
}

- (void) runWithCompletion:(void ( ^ _Nonnull )(BOOL successful))completion
{
    [self getASyncWithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(data && !error && [data isKindOfClass:[NSDictionary class]])
        {
            // Get the bus locations and convert it into objects
            NSArray* estimates = data[@"estimates"];
            NSMutableArray* result = [NSMutableArray array];
            [estimates enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [result addObject:[[BusStopComingBus alloc] initWithDictionary:obj ]];
            }];
            
            // Sort them and save the result
            _sortedComingBuses = [result sortedArrayUsingComparator:^NSComparisonResult(BusStopComingBus*  _Nonnull obj1, BusStopComingBus*  _Nonnull obj2) {
                return [@(obj1.estimate) compare:@(obj2.estimate)];
            }];
            
            completion(true);
        }else {
            completion(false);
        }
    }];
}

@end

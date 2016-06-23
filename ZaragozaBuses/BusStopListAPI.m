//
//  ReviewAPI.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "BusStopListAPI.h"
#import "WebBaseAPI.h"
//#import "Place.h"

@interface BusStopListAPI()
@end

@implementation BusStopListAPI

@synthesize busStops = _busStops;


-(instancetype _Nullable) init
{
    self = [super init];
    if(self)
    {
        self.jsonEndPoint = @"http://api.dndzgz.com/services/bus";
    }
    return self;
}

- (void) runWithCompletion:(void ( ^ _Nonnull )(BOOL successful))completion
{
    [self getASyncWithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(data && !error && [data isKindOfClass:[NSDictionary class]])
        {
            // Get the bus locations and convert it into objects
            NSArray* busLocations = data[@"locations"];
            NSMutableArray* busLocationsResult = [NSMutableArray array];
            [busLocations enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [busLocationsResult addObject:[[BusStop alloc] initWithDictionary:obj]];
            }];
            _busStops = [NSArray arrayWithArray:busLocationsResult];
            completion(true);
        }else {
            completion(false);
        }
    }];
}

@end

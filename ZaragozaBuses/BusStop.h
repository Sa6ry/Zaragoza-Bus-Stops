//
//  PlaceSuggestion.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface BusStop : NSObject

// Currently we are going to expose only the fullName and the location
// If any other information is needed it should be exposed by adding
// the corsponding property

@property (nonatomic,readonly) NSString* _Nonnull locationID;

@property (nonatomic,readonly) NSArray<NSString*>* _Nonnull lines;

@property (nonatomic,readonly) NSString* _Nonnull title;

@property (nonatomic,readonly) NSString* _Nonnull subtitle;

@property (nonatomic,readonly) CLLocationCoordinate2D GeoPosition;

@property (nonatomic,readonly) CLLocation* _Nonnull location;

-(NSNumber* _Nonnull) distanceFromLocation:(CLLocation* _Nullable) location;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithDictionary: instead.")));
- (instancetype _Nullable) initWithDictionary:(NSDictionary* _Nonnull)data;

+(NSArray<BusStop*>* _Nonnull) orderByStationNumber:(NSArray<BusStop*>* _Nonnull) busStops;

+(NSArray<BusStop*>* _Nonnull) order:(NSArray<BusStop*>* _Nonnull) busStops byLocation:(CLLocation* _Nonnull) location;

+(NSArray<BusStop*>* _Nonnull) filter:(NSArray<BusStop*>* _Nonnull) busStops withText:(NSString* _Nonnull)text;

@end

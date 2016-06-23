//
//  PlaceSuggestion.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "BusStop.h"

@interface BusStop()
@property (nonatomic,retain) NSDictionary* data;
@end

@implementation BusStop

-(id) initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if(self)
    {
        self.data = data;
    }
    return self;
}

-(NSString*) locationID
{
    return self.data[@"id"];
}

-(NSString*) title
{
    return self.data[@"title"];
}

-(NSString*) subtitle
{
    return self.data[@"subtitle"];
}

-(CLLocationCoordinate2D) GeoPosition
{
    CLLocationCoordinate2D res = { [self.data[@"lat"] doubleValue],
        [self.data[@"lon"] doubleValue]};
    return res;
}

-(CLLocation*) location
{
    return [[CLLocation alloc] initWithLatitude:self.GeoPosition.latitude longitude:self.GeoPosition.longitude];
}

-(NSNumber*) distanceFromLocation:(CLLocation*) location
{
    return @([self.location distanceFromLocation:location]);
}

+(NSArray<BusStop*>* _Nonnull) orderByStationNumber:(NSArray<BusStop*>* _Nonnull) busStops
{
    return [busStops sortedArrayUsingComparator:^NSComparisonResult(BusStop*  _Nonnull obj1, BusStop*  _Nonnull obj2) {
        return obj1.locationID.integerValue - obj2.locationID.integerValue;
    }];
}

+(NSArray<BusStop*>* _Nonnull) order:(NSArray<BusStop*>* _Nonnull) busStops byLocation:(CLLocation* _Nonnull) location {
    return [busStops sortedArrayUsingComparator:^NSComparisonResult(BusStop*  _Nonnull obj1, BusStop*  _Nonnull obj2) {
        return [[obj1 distanceFromLocation:location] compare:[obj2 distanceFromLocation:location]];
    }];
}

+(NSArray<BusStop*>* _Nonnull) filter:(NSArray<BusStop*>* _Nonnull) busStops withText:(NSString* _Nonnull)text
{
    if(text == nil || text.length == 0) {
        return [busStops copy];
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.title CONTAINS[cd] %@) OR (self.locationID CONTAINS[cd] %@)", text, text];
        
        NSArray<BusStop*>* filteredResult = [busStops filteredArrayUsingPredicate:predicate];
        
        // sort by most relevant
        return [filteredResult sortedArrayUsingComparator:^NSComparisonResult(BusStop*  _Nonnull obj1, BusStop*  _Nonnull obj2) {
            if([obj1.locationID isEqualToString:text]) {
                return NSOrderedAscending;
            }
            else if([obj2.locationID isEqualToString:text]) {
                return NSOrderedDescending;
            }
            else if([obj1.title hasPrefix:text] || [obj1.locationID hasPrefix:text] ) {
                return NSOrderedAscending;
            }else if([obj2.title hasPrefix:text] || [obj2.locationID hasPrefix:text] ) {
                return NSOrderedDescending;
            }else {
                return NSOrderedSame;
            }
        }];
    }
}

-(NSString*) description
{
    return [self.data description];
}
@end

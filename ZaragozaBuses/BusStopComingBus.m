//
//  PlaceSuggestion.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "BusStopComingBus.h"

@interface BusStopComingBus()
@property (nonatomic,retain) NSDictionary* data;
@end

@implementation BusStopComingBus

-(id) initWithDictionary:(NSDictionary*)data
{
    self = [super init];
    if(self)
    {
        self.data = data;
    }
    return self;
}

-(NSString*) line
{
    return self.data[@"line"];
}

-(NSInteger) estimate
{
    if([self.data[@"estimate"] isKindOfClass:[NSNumber class]]) {
        return [self.data[@"estimate"] integerValue];
    }else {
        return NSNotFound;
    }
}

-(NSString*) direction
{
    return self.data[@"direction"];
}

-(NSString*) description
{
    return [self.data description];
}
@end

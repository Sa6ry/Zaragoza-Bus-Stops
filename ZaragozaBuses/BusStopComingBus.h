//
//  PlaceSuggestion.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface BusStopComingBus : NSObject

// Currently we are going to expose only the fullName and the location
// If any other information is needed it should be exposed by adding
// the corsponding property

@property (nonatomic,readonly) NSString* _Nonnull  line;
@property (nonatomic,readonly) NSInteger  estimate;
@property (nonatomic,readonly) NSString* _Nonnull direction;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithDictionary: instead.")));
- (instancetype _Nullable) initWithDictionary:(NSDictionary* _Nonnull)data;

@end

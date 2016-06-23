//
//  GoogleMapImageAPI.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/23/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "GoogleMapImageAPI.h"

@implementation GoogleMapImageAPI
@synthesize  image = _image;

- (instancetype _Nullable) initWithCoordinate:(CLLocationCoordinate2D ) coordiante
{
    self = [super init];
    if(self) {
        
        self.imageEndPoint = @"https://maps.googleapis.com/maps/api/staticmap";
        self.params = @{@"center" : [NSString stringWithFormat:@"%f,%f",coordiante.latitude,coordiante.longitude],
                        @"zoom":@"15",
                        @"size":@"200x200",
                        @"sensor":@"true"};
                        
                        //@"markers": [NSString stringWithFormat:@"color:blue|label:87|%f,%f",coordiante.latitude,coordiante.longitude]
    }
    return self;
}

-(void) runWithCompletion:(void (^)(BOOL))completion
{
    [self getASyncWithCompletion:^(id  _Nullable data, NSError * _Nullable error) {
        
        if(data && !error && [data isKindOfClass:[UIImage class]])
        {
            _image = data;
            
            completion(true);
        }else {
            completion(false);
        }
    }];
}



@end

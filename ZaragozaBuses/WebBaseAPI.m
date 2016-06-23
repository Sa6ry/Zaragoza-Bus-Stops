//
//  WebBaseAPI.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "WebBaseAPI.h"

@interface WebBaseAPI()
@property (nonatomic,readonly) NSURL* queryURL;
@property (nonatomic,readonly) NSString* endPoint;
@property (nonatomic,retain) NSURLSessionDataTask* dataTask;
@end

@implementation WebBaseAPI

-(NSString*) endPoint
{
    if(self.jsonEndPoint)
    {
        return self.jsonEndPoint;
    }else {
        return self.imageEndPoint;
    }
}
-(NSURL*) queryURL
{
    // Build the query string
    NSURLComponents *components = [NSURLComponents componentsWithString:self.endPoint];
    NSMutableArray* queryItems = [NSMutableArray array];
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:obj]];
    }];
    components.queryItems = queryItems;
    return components.URL;
}

-(void) getASyncWithCompletion:(void ( ^ _Nonnull )(id _Nullable data, NSError * _Nullable error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.queryURL];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    self.dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id result = data;
        if(!data) {
            result = nil;
        }
        else if(self.jsonEndPoint) {
           result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        else if(self.imageEndPoint) {
            result = [UIImage imageWithData:data];
        }
        
        self.dataTask = nil;
        
        completion(result,error);
        
    }];
    
    [self.dataTask resume];
}

-(void) cancel {
    [self.dataTask cancel];
}

- (void) runWithCompletion:(void ( ^ _Nonnull )(BOOL successful))completion
{
    NSAssert(false, @"Override this method in the child API");
}

@end

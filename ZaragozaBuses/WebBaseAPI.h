//
//  WebBaseAPI.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebBaseAPI : NSObject

@property (nonatomic,strong) NSString* _Nonnull imageEndPoint;
@property (nonatomic,strong) NSString* _Nonnull jsonEndPoint;
@property (nonatomic,strong) NSDictionary* _Nonnull params;

@property (nonatomic,assign) NSInteger tag;

-(void) getASyncWithCompletion:(void ( ^ _Nonnull )(id _Nullable data, NSError * _Nullable error))completion;

// needs to be override by the children classes
- (void) runWithCompletion:(void ( ^ _Nonnull )(BOOL successful))completion;

-(void) cancel;

@end

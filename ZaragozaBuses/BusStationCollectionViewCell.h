//
//  BusStationCollectionViewCell.h
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/23/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusStationCollectionViewCell : UICollectionViewCell


@property (nonatomic,strong) NSString* stationTitle;
@property (nonatomic,strong) NSString* stationNumber;
@property (nonatomic,strong) NSString* busNumber;
@property (nonatomic,strong) NSString* busEstimate;

@property (nonatomic, strong) UIImage *mapImage;

@property (strong,nonatomic) id userDefinedObj1;
@property (strong,nonatomic) id userDefinedObj2;

-(void) hideBusInfo:(BOOL)hide;

@end

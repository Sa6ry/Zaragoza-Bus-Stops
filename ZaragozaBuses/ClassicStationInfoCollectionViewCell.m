//
//  StationInfoCollectionViewCell.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/21/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "ClassicStationInfoCollectionViewCell.h"

@interface ClassicStationInfoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *busInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *stationTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *busNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *busEstimateLabel;
@end

@implementation ClassicStationInfoCollectionViewCell

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    [self prepareUI];
    
}

-(void) prepareUI
{
    self.stationNumberLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.stationNumberLabel.layer.borderWidth = 1.0f;
    self.stationNumberLabel.layer.cornerRadius = 5.0f;
    
    self.busInfoContainer.layer.borderWidth = 1.0f;
    self.busInfoContainer.layer.borderColor = self.busInfoContainer.tintColor.CGColor;
    
    self.busNumberLabel.layer.cornerRadius = 5.0;
    self.busNumberLabel.clipsToBounds = YES;
    
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1.0f;
    self.clipsToBounds = YES;
    
    self.layer.borderColor = self.tintColor.CGColor;
    
    [self hideBusInfo:YES];
}

-(void) prepareForReuse
{
    self.mapImage = nil;
    [self hideBusInfo:YES];
}

-(void) hideBusInfo:(BOOL)hide
{
    self.busInfoContainer.alpha= hide ? 0.0 : 1.0;
}

#pragma mark override the setters
-(void) setStationTitle:(NSString *)stationTitle
{
    [super setStationTitle:stationTitle];
    self.stationTitleLabel.text = stationTitle;
}

-(void) setStationNumber:(NSString *)stationNumber
{
    [super setStationNumber:stationNumber];
    self.stationNumberLabel.text = stationNumber;
}

-(void) setBusEstimate:(NSString *)busEstimate
{
    [super setBusEstimate:busEstimate];
    if(busEstimate) {
        self.busEstimateLabel.text = busEstimate;
        self.busEstimateLabel.hidden = NO;
    }else {
        self.busEstimateLabel.hidden = YES;
    }
}

-(void) setMapImage:(UIImage *)mapImage
{
    [super setMapImage: mapImage];
    self.mapImageView.image = mapImage;
}

@end

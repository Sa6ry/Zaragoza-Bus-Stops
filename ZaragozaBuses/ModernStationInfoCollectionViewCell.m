//
//  ModernStationInfoCollectionViewCell.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/23/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "ModernStationInfoCollectionViewCell.h"

@interface ModernStationInfoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *stationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingBusLabel;

@end


@implementation ModernStationInfoCollectionViewCell

-(void) cleanCell {
    self.backgroundColor = [UIColor darkGrayColor];
    self.comingBusLabel.alpha = 0.0;
}

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    [self cleanCell];
}
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

-(UIColor*) colorForEstimate:(double) estimate
{
    CGFloat percent = MIN(1.0, estimate/15.0);
    
    UIColor *color1 = [UIColor colorWithHue:7.0/360.0 saturation:0.76 brightness:0.76 alpha:1]; //red
    UIColor *color2 = [UIColor colorWithHue:155.0/360.0 saturation:0.76 brightness:0.64 alpha:1]; //green
    CGFloat r1, r2, g1, g2, b1, b2, a1, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    UIColor *avg = [UIColor colorWithRed:r1*percent + r2*(1.0-percent)
                                   green:g1*percent + g2*(1.0-percent)
                                    blue:b1*percent + b2*(1.0-percent)
                                   alpha:a1*percent + a2*(1.0-percent)];
    return avg;
}

-(void) prepareForReuse
{
    [super prepareForReuse];
    [self cleanCell];
}
-(void) setBusEstimate:(NSString *)busEstimate
{
    [super setBusEstimate:busEstimate];
    
    // update the background color based on the estimate
    if(busEstimate) {
        self.backgroundColor = [self colorForEstimate:busEstimate.floatValue];
        
        self.comingBusLabel.text = [NSString stringWithFormat:@"%@ bus coming in %@ minute%@",self.busNumber, self.busEstimate,self.busEstimate.integerValue <= 1 ? @"" : @"s"];
        self.comingBusLabel.alpha = 1.0;
    }
    
}

@end

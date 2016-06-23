//
//  ModernBusListViewController.m
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/23/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "ModernBusListViewController.h"
#import "BusStopListAPI.h"
#import "GoogleMapImageAPI.h"
#import "BusStationCollectionViewCell.h"
#import "BusStopComingBusesAPI.h"
#import <MapKit/MapKit.h>

@interface ModernBusListViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,readonly) NSArray<BusStop*>* busStops;
@property (nonatomic,strong) NSArray<BusStop*>* allBusStops;
@property (nonatomic,strong) NSArray<BusStop*>* filteredBusStops;
// the user geo location
@property (nonatomic,strong) CLLocation* userLocation;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,assign) NSUInteger lastSelectedIndex;

@end

@implementation ModernBusListViewController

static NSString * const reuseIdentifier = @"Cell";

-(void) dealloc
{
    [self removeKeyboardObservers];
}

-(NSArray<BusStop*>*) busStops
{
    return self.filteredBusStops ? self.filteredBusStops : self.allBusStops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"modernBusCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    BusStopListAPI* api = [[BusStopListAPI alloc] init];
    [api runWithCompletion:^(BOOL successful) {
        if(successful)
        {
            self.allBusStops = api.busStops;
            // order them
            [self updateCurrentLocation];
            self.allBusStops = [BusStop orderByStationNumber:self.allBusStops];
            self.allBusStops = [BusStop order:self.allBusStops byLocation:self.userLocation];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }
    }];
    
    [self addKeyboardObservers];
    
    
    
    // Set the zoom level of mapview
    CLLocationCoordinate2D noLocation = self.mapView.centerCoordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
    self.mapView.showsUserLocation = YES;
    
    // intialling hide the map till the user select a station
    //self.mapView.hidden = YES;
    self.mapViewContainer.hidden = YES;
    
    self.lastSelectedIndex = NSNotFound;
    
    self.collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.collectionView.layer.borderWidth = 1.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // force recalculating the item size upon rotation
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Keyboard Observers
-(void) addKeyboardObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) removeKeyboardObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    self.collectionViewBottomConstraint.constant = height;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:animationDuration animations:^{
        self.mapViewContainer.hidden = YES;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) keyboardWillHide:(NSNotification*) notification {
    
    NSDictionary *info = [notification userInfo];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.collectionViewBottomConstraint.constant = 0;
        } completion:^(BOOL finished) {
            
        }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
-(BOOL) textFieldShouldClear:(UITextField *)textField
{
    [self updateUserSearch:@""];
    return true;
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateUserSearch:newText];
    return true;
}

-(void) updateUserSearch:(NSString*)newSearch {
    self.filteredBusStops = [BusStop filter:self.allBusStops withText:newSearch];
    [self.collectionView reloadData];
}

#pragma mark map
-(void) updateMapLocationAtItem:(NSUInteger)itemIndex animated:(BOOL)animated
{
    
    CLLocationCoordinate2D mapLocation = self.busStops[itemIndex].GeoPosition;
    
    mapLocation.latitude += self.mapView.region.span.latitudeDelta * 0.4;
    
    [self.mapView setCenterCoordinate:mapLocation animated:animated];
    
    // Place a single pin
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.busStops[itemIndex].GeoPosition];
    [annotation setTitle:[NSString stringWithFormat:@"%@ - %@",self.busStops[itemIndex].locationID,self.busStops[itemIndex].title ]]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

#pragma mark <UICollectionViewDataSource>

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedIndex = indexPath.item;
    
    if([self.searchTextField isFirstResponder]) {
        // keyboard shown, map hidden
        [self.searchTextField resignFirstResponder];
        [self updateMapLocationAtItem:indexPath.row animated:NO];
    }else {
        if(self.mapViewContainer.hidden == YES) {
            [UIView animateWithDuration:0.5 animations:^{
                [self updateMapLocationAtItem:indexPath.row animated:NO];
                self.mapViewContainer.hidden = NO;
            }];
            
        }else {
            [self updateMapLocationAtItem:indexPath.row animated:YES];
        }
        
    }
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.busStops.count;
}

-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusStationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.stationTitle = self.busStops[indexPath.item].title;
    cell.stationNumber = [NSString stringWithFormat:@"%@", self.busStops[indexPath.item].locationID];
    
    
    //////////////////////////////
    // Update the incomming bus
    //////////////////////////////
    BusStopComingBusesAPI *comingBus = [[BusStopComingBusesAPI alloc] initWithBusStopID:self.busStops[indexPath.item].locationID.integerValue];
    cell.userDefinedObj2 = [NSValue valueWithNonretainedObject:comingBus];
    [comingBus runWithCompletion:^(BOOL successful) {
        if(successful) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if([cell.userDefinedObj2 isEqualToValue:[NSValue valueWithNonretainedObject:comingBus]]) {
                    BusStopComingBus* busInfo = comingBus.sortedComingBuses.firstObject;
                    cell.busNumber = [NSString stringWithFormat:@"%@", busInfo.line];
                    if(busInfo.estimate != NSNotFound) {
                        cell.busEstimate = [NSString stringWithFormat:@"%ld", (long)comingBus.sortedComingBuses.firstObject.estimate];
                    }else {
                        cell.busEstimate = nil;
                    }
                    
                    [cell hideBusInfo:NO];
                }
            }];
            
        }
    }];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat spacing = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).minimumLineSpacing;
    
    return UIEdgeInsetsMake(spacing,spacing,spacing,spacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat cellSpacing = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).minimumLineSpacing;
    
    CGFloat noOfColumns = 2.0;
    
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        // Compact width
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            // landscape
            noOfColumns = 2;
        }
        else
        {
            // Portait
            noOfColumns = 1;
        }
    }
    else {
        noOfColumns = 3;
    }
    
    CGFloat colWidth = (self.collectionView.bounds.size.width-(noOfColumns+1.0)*cellSpacing)/(noOfColumns);
    return CGSizeMake(colWidth, 90);
}

#pragma mark - Getting the current location
-(CLLocationCoordinate2D) updateCurrentLocation
{
    ///////////////////////////////////////////////////
    // this logic should be moved to a seperate class
    ///////////////////////////////////////////////////
    
    static dispatch_once_t onceToken;
    static CLLocationManager* locationManager = nil;
    dispatch_once (&onceToken, ^{
        // Do some work that happens once
        locationManager = [[CLLocationManager alloc] init];
    });
    
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    self.userLocation = [locationManager location];
    CLLocationCoordinate2D coordinate = [self.userLocation coordinate];
    return coordinate;
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    
    self.allBusStops = [BusStop order:self.allBusStops byLocation:self.userLocation];
    
    // update the data
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.collectionView reloadData];
    }];
    
}

@end

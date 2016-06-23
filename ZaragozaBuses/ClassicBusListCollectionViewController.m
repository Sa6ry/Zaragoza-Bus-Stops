//
//  ClassicBusListCollectionViewController
//  ZaragozaBuses
//
//  Created by Ahmed Sabry on 6/20/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "ClassicBusListCollectionViewController.h"
#import "BusStopListAPI.h"
#import "GoogleMapImageAPI.h"
#import "BusStationCollectionViewCell.h"
#import "BusStopComingBusesAPI.h"

@interface ClassicBusListCollectionViewController ()
@property (nonatomic,strong) NSArray<BusStop*>* busStops;
// the user geo location
@property (nonatomic,strong) CLLocation* currentLocation;
@property (assign, nonatomic) NSUInteger selectedSortIndex;
@end

@implementation ClassicBusListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"classicBusCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    BusStopListAPI* api = [[BusStopListAPI alloc] init];
    [api runWithCompletion:^(BOOL successful) {
        if(successful)
        {
            self.busStops = api.busStops;
            // order them
            self.busStops = [BusStop orderByStationNumber:self.busStops];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }
    }];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    // We want smooth animation (hide & show status bar) while scrolling down
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // force recalculating the item size upon rotation
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark Reload data
-(void) reloadData {
    switch (self.selectedSortIndex) {
        case 0:
            // order by station numbers
            self.busStops = [BusStop orderByStationNumber:self.busStops];
            [self.collectionView reloadData];
            break;
        case 1:
            // order by near by
            if(self.currentLocation == nil) {
                [self updateCurrentLocation];
            }else {
                self.busStops = [BusStop order:self.busStops byLocation:self.currentLocation];
                [self.collectionView reloadData];
            }
            break;
        default:
            break;
    }
}
#pragma mark <UICollectionViewDataSource>

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
    cell.stationNumber = [NSString stringWithFormat:@" %ld ", self.busStops[indexPath.item].locationID];
    
    /////////////////////////
    // Update the map image
    /////////////////////////
    GoogleMapImageAPI* googleMap = [[GoogleMapImageAPI alloc] initWithCoordinate:self.busStops[indexPath.item].GeoPosition ];
    cell.userDefinedObj1 = [NSValue valueWithNonretainedObject:googleMap];
    
    [googleMap runWithCompletion:^(BOOL successful) {
        if(successful) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if([cell.userDefinedObj1 isEqualToValue:[NSValue valueWithNonretainedObject:googleMap]]) {
                    cell.mapImage = googleMap.image;
                }
            }];
        }
    }];
    
    //////////////////////////////
    // Update the incomming bugs
    //////////////////////////////
    BusStopComingBusesAPI *comingBus = [[BusStopComingBusesAPI alloc] initWithBusStopID:self.busStops[indexPath.item].locationID];
    cell.userDefinedObj2 = [NSValue valueWithNonretainedObject:comingBus];
    [comingBus runWithCompletion:^(BOOL successful) {
        if(successful) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if([cell.userDefinedObj2 isEqualToValue:[NSValue valueWithNonretainedObject:comingBus]]) {
                    BusStopComingBus* busInfo = comingBus.sortedComingBuses.firstObject;
                    cell.busNumber = [NSString stringWithFormat:@"%@", busInfo.line];
                    if(busInfo.estimate != NSNotFound) {
                        cell.busEstimate = [NSString stringWithFormat:@"%ld min", (long)comingBus.sortedComingBuses.firstObject.estimate];
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

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat cellSpacing = ((UICollectionViewFlowLayout*)self.collectionViewLayout).minimumLineSpacing;
    
    CGFloat noOfColumns = 2.0;
    
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        // Compact width
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            // landscape
            noOfColumns = 3;
        }
        else
        {
            // Portait
            noOfColumns = 2;
        }
    }
    else {
        noOfColumns = 4;
    }
    
    CGFloat colWidth = (self.collectionView.bounds.size.width-(noOfColumns+1.0)*cellSpacing)/(noOfColumns);
    return CGSizeMake(colWidth, colWidth+20);
}
#pragma mark titlebar actions

- (IBAction)onSortOrderChange:(UISegmentedControl*)sender {
    
    self.selectedSortIndex = sender.selectedSegmentIndex;
    
    [self reloadData];
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
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
    
    // update the data
    [self reloadData];
}

@end

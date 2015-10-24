//
//  ViewController.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 23/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ESTIndoorLocationManagerDelegate>

@property (nonatomic) ESTIndoorLocationManager *locationManager;
@property (nonatomic) ESTLocation *location;

@end





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 4. Instantiate the location manager & set its delegate
    [ESTConfig setupAppID:@"money2020-hkx" andAppToken:@"11620815090eb88f60683cda6ab5fd5a"];
    self.locationManager = [ESTIndoorLocationManager new];
    self.locationManager.delegate = self;
    
    [self.locationManager fetchLocationByIdentifier:@"my-kitchen" withSuccess:^(id object) {
        self.location = object;
        [self.locationManager startIndoorLocation:self.location];

    } failure:^(NSError *error) {
        NSLog(@"can't fetch location: %@", error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-    (void)indoorLocationManager:(ESTIndoorLocationManager *)manager
didFailToUpdatePositionWithError:(NSError *)error {
    NSLog(@"failed to update position: %@", error);
}

- (void)indoorLocationManager:(ESTIndoorLocationManager *)manager
            didUpdatePosition:(ESTOrientedPoint *)position
                 withAccuracy:(ESTPositionAccuracy)positionAccuracy
                   inLocation:(ESTLocation *)location {
    NSString *accuracy;
    switch (positionAccuracy) {
        case ESTPositionAccuracyVeryHigh: accuracy = @"+/- 1.00m"; break;
        case ESTPositionAccuracyHigh:     accuracy = @"+/- 1.62m"; break;
        case ESTPositionAccuracyMedium:   accuracy = @"+/- 2.62m"; break;
        case ESTPositionAccuracyLow:      accuracy = @"+/- 4.24m"; break;
        case ESTPositionAccuracyVeryLow:  accuracy = @"+/- ? :-("; break;
    }
    NSLog(@"x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
          position.x, position.y, position.orientation, accuracy);
}


@end

//
//  ShoppingCartViewController.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 24/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import <QuartzCore/QuartzCore.h>
#import <Simplify/SIMChargeCardViewController.h>
#import <PubNub/PubNub.h>

#import "ESTIndoorLocationViewController.h"
#import "ESTIndoorLocationManager.h"
#import "ESTIndoorLocationView.h"
#import "ESTPositionView.h"
#import <AFNetworking/AFNetworking.h>
#import "CartViewController.h"
#import "ESTBeacon.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:1]

// Update these to match your required settings
//
NSString * const REGION_IDENTIFER           = @"regionid";
CLBeaconMajorValue BEACON_MAJOR_VERSION     = 20283;
CLBeaconMajorValue BEACON_MINOR_VERSION     = 38514;

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource, ShoppingCellDelegate, SIMChargeCardViewControllerDelegate, ESTBeaconManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *numProducts;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property ( nonatomic) NSInteger totalNumProducts;
@property ( nonatomic) NSInteger totalAmount;
@property (nonatomic) ESTIndoorLocationManager *locationManager;
@property (nonatomic) ESTLocation *location;
@property (nonatomic) PubNub *client;
@property (nonatomic) ESTOrientedPoint *currentLocationPoint;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic ,strong) ESTPoint *beaconEntrance;
@property (nonatomic ,strong) NSString *previouslocation;
@property (nonatomic, strong) NSString *firstTime;
@property (nonatomic ,strong) ESTPoint *beaconWall;
@property (nonatomic) BOOL isLocationChanged;
@property NSArray *products;
@property (nonatomic, strong) ESTBeaconManager* beaconManager;

@property(nonatomic, strong) UIBarButtonItem *numItem;
@property(nonatomic, strong) UIBarButtonItem *beaconItem;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Shop";
    self.totalNumProducts = 0;
    self.totalAmount = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if(self.firstTime) {
    
    }
    self.navigationItem.hidesBackButton = YES;
    
    
    self.title = @"HouseHold";
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icnCart"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonPressed)];
    self.beaconItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icnBeaconOn"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = self.beaconItem;
    self.numItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.numItem.tintColor = RGBCOLOR(0.0, 224.0, 128.0);
    self.beaconItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[item1,self.numItem] ;
    self.navigationItem.rightBarButtonItem.tintColor = RGBCOLOR(22, 21, 15);
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firstTime = @"YES";
       self.checkoutButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
    self.checkoutButton.enabled = NO;
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width /2.2;
    self.numberLabel.layer.masksToBounds = YES;
    [self changeCheckoutValues];
    self.tableView.tableFooterView = [UIView new]
    ;
    self.previouslocation = @"asdads";
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                       major:BEACON_MAJOR_VERSION
                                                                       minor:BEACON_MINOR_VERSION
                                                                  identifier:REGION_IDENTIFER];
    
    [self.beaconManager startRangingBeaconsInRegion:region];
    
    self.isLocationChanged = NO;
    
    
    //[self getAllProducts:40 y:40];
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-8bd872c9-064b-48b1-84cc-4827a9c77968"
                                                                     subscribeKey:@"sub-c-e412cdee-7adb-11e5-ad8e-02ee2ddab7fe"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                   selector: @selector(sendPosition) userInfo: nil repeats: YES];
    
    
    
}

-(void)cartButtonPressed{
    [self performSegueWithIdentifier:@"showCart" sender:self];
}

-(void)sendPosition {
    if(self.currentLocationPoint) {
        [self.client publish: @{@"x" : [NSNumber numberWithDouble: self.currentLocationPoint.x], @"y" : [NSNumber numberWithDouble: self.currentLocationPoint.y]} toChannel: @"money2020" storeInHistory:YES
              withCompletion:^(PNPublishStatus *status) {
                  
                  // Check whether request successfully completed or not.
                  if (!status.isError) {
                      
                      // Message successfully published to specified channel.
                  }
                  // Request processing failed.
                  else {
                      
                      // Handle message publish error. Check 'category' property to find out possible issue
                      // because of which request did fail.
                      //
                      // Request can be resent using: [status retry];
                  }
              }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showCart"])
    {
        // Get reference to the destination view controller
        CartViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.numProducts = self.numProducts;
        vc.totalAmount = self.totalAmount;
        vc.totalNumProducts = self.totalNumProducts;
        vc.products = self.products;
    }
}
- (IBAction)checkout:(id)sender {
    PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = @"merchant.com.velle.money2020";
    paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    paymentRequest.countryCode = @"US";
    PKPaymentSummaryItem *item = [PKPaymentSummaryItem summaryItemWithLabel:@"Test Item" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    paymentRequest.paymentSummaryItems = @[item];
    paymentRequest.currencyCode = @"USD";
    SIMChargeCardViewController *chargeVC = [[SIMChargeCardViewController alloc] initWithPublicKey:@"sbpb_NjhjODgwNTctNDVkYS00MzNmLWFmZDgtYzkzMTcyZTgwZmZl" paymentRequest:paymentRequest];
    
    //3. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    chargeVC.delegate = self;
    
    [self presentViewController:chargeVC animated:YES completion:nil];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ShoppingCell";
    
    ShoppingCartCell *cell = (ShoppingCartCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    cell.name.text = product[@"name"];
    cell.delegate = self;
    if([UIImage imageNamed:product[@"image"]]) {
        cell.imageProduct.image = [UIImage imageNamed:product[@"image"]];
    }
    cell.cardView.layer.masksToBounds = NO;
    cell.cardView.layer.shadowOffset = CGSizeMake(0, 1);
   // cell.cardView.layer.shadowColor = RGBCOLOR(248.0, 248.0, 248.0).CGColor;
    cell.cardView.layer.shadowRadius = 1;
    cell.cardView.layer.shadowOpacity = 0.5;
    cell.cardView.layer.cornerRadius = 5.0;
    cell.price.text = [NSString stringWithFormat:@"$%d", [product[@"price"] intValue]];
    cell.number.text = [NSString stringWithFormat:@"%d", [[self.numProducts objectAtIndex:indexPath.row] intValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeCheckoutValues {
    if(self.totalNumProducts != 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.totalNumProducts];
        self.numberLabel.hidden = NO;
        self.totalAmountLabel.hidden = NO;
        self.totalAmountLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.totalAmount];
        self.checkoutButton.enabled = YES;
        self.checkoutButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0f];
        
        self.numItem.title =  [NSString stringWithFormat:@"%ld", (long)self.totalNumProducts];
    }
    else {
        self.numberLabel.hidden = YES;
        self.totalAmountLabel.hidden = YES;
        self.checkoutButton.enabled = NO;
        self.checkoutButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
        self.numItem.title = @"";

    }
    
}
-(void)didPressSubtractButton:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%@",self.products[indexPath.row]);
    if([self.numProducts[indexPath.row] intValue] != 0) {
        self.numProducts[indexPath.row] = [NSNumber numberWithInteger:[self.numProducts[indexPath.row] intValue] - 1];
        self.totalNumProducts --;
        self.totalAmount = self.totalAmount -  [self.products[indexPath.row][@"price"] intValue];
    }
    NSLog(@"%d",[self.numProducts[indexPath.row] intValue]);
    [self changeCheckoutValues];
    [self.tableView reloadData];
}
-(void)didPressAddButton:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%@",self.products[indexPath.row]);
        self.numProducts[indexPath.row] = [NSNumber numberWithInteger:[self.numProducts[indexPath.row] intValue] + 1];
     self.totalAmount = self.totalAmount +  [self.products[indexPath.row][@"price"] intValue];
    self.totalNumProducts++;
    
    [self changeCheckoutValues];
    [self.tableView reloadData];
}



-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    
    //Process the provided token
    NSLog(@"Token:%@", token.token);
    [self performSegueWithIdentifier:@"verifySegue" sender:self];
}

-(void)chargeCardCancelled {
    
    //User cancelled the SIMChargeCardViewController
    NSLog(@"User Cancelled");
    
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
    
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
    self.currentLocationPoint = position;
    switch (positionAccuracy) {
        case ESTPositionAccuracyVeryHigh: accuracy = @"+/- 1.00m"; break;
        case ESTPositionAccuracyHigh:     accuracy = @"+/- 1.62m"; break;
        case ESTPositionAccuracyMedium:   accuracy = @"+/- 2.62m"; break;
        case ESTPositionAccuracyLow:      accuracy = @"+/- 4.24m"; break;
        case ESTPositionAccuracyVeryLow:  accuracy = @"+/- ? :-("; break;
    }
    NSLog(@"x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
          position.x, position.y, position.orientation, accuracy);
    self.beaconEntrance = [[ESTPoint alloc] initWithX:10.0 y:14];;
    self.beaconWall = [[ESTPoint alloc] initWithX:-10.0 y:7.0];;


     if ([self.currentLocationPoint
              distanceToPoint:self.beaconWall] < 5 && ![self.previouslocation isEqualToString:@"exit"]) {
        [self getAllProducts:0 y:0];
    }
     else  {
         [self removeallproducts];
     }
}


-(void)removeallproducts {
    if(self.products.count >0) {
        self.products = @[];
        [self.tableView reloadData];
        self.beaconItem.tintColor = [UIColor blackColor];

    }
}
-(void)getAllProducts:(int)x y: (int)y {

    if(self.products.count == 0) {
        self.products = @[@{@"id" : @"1", @"name" : @"Clorox Disinfectant Wipes 3 x 35 ct", @"price" : [NSNumber numberWithInt:6], @"image" : @"imgPrd1"},@{@"id" : @"2", @"name" : @"Dawn Ultra Original Dishwashing Liquid", @"price" :[NSNumber numberWithInt:2], @"image" : @"imgPrd2"}, @{@"id" : @"3", @"name" : @"Dreft Stage 1: New Born HEC Liquid", @"price" :[NSNumber numberWithInt:3], @"image" : @"imgPrd4"}, @{@"id" : @"4", @"name" : @"Seventh Generation Natural Dish Liquid", @"price" :[NSNumber numberWithInt:4], @"image" : @"imgPrd5"}];
        self.numProducts = [NSMutableArray new];
        for(int i = 0; i < self.products.count ; i++) {
            [self.numProducts addObject:[NSNumber numberWithInt:0] ];
        }
        self.beaconItem.tintColor = RGBCOLOR(0.0, 224.0, 128.0);

        [self.tableView reloadData];
    }
    
}


- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    if ([beacons count] > 0) {
        ESTBeacon *closestBeacon = [beacons firstObject];
        
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:closestBeacon waitUntilDone:YES];
    }
}

- (void)updateUI:(ESTBeacon *)beacon
{
   
    
    switch (beacon.proximity) {
        case CLProximityImmediate:
        {
            [self getAllProducts:0 y:0];
    
        }
            break;
        case CLProximityNear:
        {
            [self getAllProducts:0 y:0];
                   }
            break;
        case CLProximityFar:
        {
            [self getAllProducts:0 y:0];
        }
            break;
        case CLProximityUnknown:
        {
           [self removeallproducts];
        }
            break;
    }
    NSLog(@" Distance : %f",[beacon.distance floatValue]);
    
}
@end

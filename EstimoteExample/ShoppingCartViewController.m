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

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource, ShoppingCellDelegate, SIMChargeCardViewControllerDelegate, ESTIndoorLocationManagerDelegate>
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
    self.firstTime = @"YES";
    self.products = @[@{@"id" : @"345345", @"name" : @"Lays", @"price" : [NSNumber numberWithInt:1]},@{@"id" : @"345345", @"name" : @"Lays", @"price" :[NSNumber numberWithInt:2]}, @{@"id" : @"345345", @"name" : @"Lays", @"price" :[NSNumber numberWithInt:5]}];
    
    self.checkoutButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
    self.checkoutButton.enabled = NO;
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width /2.0;
    self.numberLabel.layer.masksToBounds = YES;
    [self changeCheckoutValues];
    self.tableView.tableFooterView = [UIView new]
    ;
    self.previouslocation = @"asdads";
    self.locationManager = [ESTIndoorLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager fetchNearbyPublicLocationsWithSuccess:^(id object) {
        self.location = [object firstObject];
        
        [self.locationManager startIndoorLocation:self.location];
        NSLog(@"%@", self.location);
    } failure:^(NSError *error) {
        
    }];
    
    self.isLocationChanged = NO;
    
    
    [self getAllProducts:40 y:40];
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-8bd872c9-064b-48b1-84cc-4827a9c77968"
                                                                     subscribeKey:@"sub-c-e412cdee-7adb-11e5-ad8e-02ee2ddab7fe"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                   selector: @selector(sendPosition) userInfo: nil repeats: YES];
    
    
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ShoppingCell";
    
    ShoppingCartCell *cell = (ShoppingCartCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    cell.name.text = product[@"name"];
    cell.delegate = self;
    if([UIImage imageNamed:product[@"id"]]) {
        cell.imageProduct.image = [UIImage imageNamed:product[@"id"]];
    }
        
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
    }
    else {
        self.numberLabel.hidden = YES;
        self.totalAmountLabel.hidden = YES;
        self.checkoutButton.enabled = NO;
        self.checkoutButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
    

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

    if ([self.currentLocationPoint distanceToPoint:self.beaconEntrance] < 15 && ![self.previouslocation isEqualToString:@"enter"]) {
        self.previouslocation = @"enter";
        [self getAllProducts:10 y:10];
    }
    else if ([self.currentLocationPoint
              distanceToPoint:self.beaconWall] < 15 && ![self.previouslocation isEqualToString:@"exit"]) {
        [self getAllProducts:40 y:40];
        self.previouslocation = @"exit";
    }
}

-(void)getAllProducts:(int)x y: (int)y {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:  [NSString stringWithFormat: @"http://52.26.246.1:9000/product/%d/%d", x, y] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.products = responseObject[@"products"];
        [self.numProducts removeAllObjects];
        for(int i = 0; i < self.products.count ; i++) {
            [self.numProducts addObject:[NSNumber numberWithInt:0] ];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end

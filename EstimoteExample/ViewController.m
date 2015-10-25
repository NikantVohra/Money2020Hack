//
//  ViewController.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 23/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "ViewController.h"
#import <Simplify/SIMChargeCardViewController.h>
#import "ESTPositionView.h"
#import "ESTIndoorLocationView.h"
#import "ESTIndoorLocationViewController.h"
@interface ViewController () <ESTIndoorLocationManagerDelegate, SIMChargeCardViewControllerDelegate>

@property (nonatomic) ESTIndoorLocationManager *locationManager;
@property (nonatomic) ESTLocation *location;
@property (weak, nonatomic) IBOutlet UIButton *shopbutton;

@end





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 4. Instantiate the location manager & set its delegate
    [ESTConfig setupAppID:@"money2020-hkx" andAppToken:@"11620815090eb88f60683cda6ab5fd5a"];
    NSLog(@"%d",[ESTConfig isAuthorized]);
    self.locationManager = [ESTIndoorLocationManager new];
    self.locationManager.delegate = self;
    

    [self.locationManager fetchNearbyPublicLocationsWithSuccess:^(id object) {
        self.location = [object firstObject];
        
        [self.locationManager startIndoorLocation:self.location];
       // ESTIndoorLocationViewController *navigationVC = [[ESTIndoorLocationViewController alloc] initWithLocation:self.location];
        //[self.navigationController pushViewController:navigationVC animated:YES];
        NSLog(@"%@", self.location);
    } failure:^(NSError *error) {
        
    }];
    //4. Add SIMChargeViewController to your view hierarchy
    
}
- (IBAction)shop:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
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

    //[self presentViewController:chargeVC animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}




-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    
    //Process the provided token
    NSLog(@"Token:%@", token.token);
    
}

-(void)chargeCardCancelled {
    
    //User cancelled the SIMChargeCardViewController
    NSLog(@"User Cancelled");
    
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
   
}


@end

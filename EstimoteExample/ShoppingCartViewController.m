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

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource, ShoppingCellDelegate, SIMChargeCardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *numProducts;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property ( nonatomic) NSInteger totalNumProducts;
@property ( nonatomic) NSInteger totalAmount;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

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
    self.products = @[@{@"id" : @"345345", @"name" : @"Lays", @"price" : [NSNumber numberWithInt:1]},@{@"id" : @"345345", @"name" : @"Lays", @"price" :[NSNumber numberWithInt:2]}, @{@"id" : @"345345", @"name" : @"Lays", @"price" :[NSNumber numberWithInt:5]}];
    self.numProducts = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], [NSNumber numberWithInt:0]]];
    self.checkoutButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f];
    self.checkoutButton.enabled = NO;
    self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width /2.0;
    self.numberLabel.layer.masksToBounds = YES;
    [self changeCheckoutValues];
    self.tableView.tableFooterView = [UIView new]
    ;}

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
    
}

-(void)chargeCardCancelled {
    
    //User cancelled the SIMChargeCardViewController
    NSLog(@"User Cancelled");
    
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
    
}
@end

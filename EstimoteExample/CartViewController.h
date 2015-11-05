//
//  CartViewController.h
//  GoCart
//
//  Created by Vohra, Nikant on 05/11/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *products;

@property ( nonatomic) NSInteger totalNumProducts;
@property ( nonatomic) NSInteger totalAmount;
@property NSMutableArray *numProducts;

@end

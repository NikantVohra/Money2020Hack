//
//  CartViewController.m
//  GoCart
//
//  Created by Vohra, Nikant on 05/11/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "CartViewController.h"
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:1]
#import <QuartzCore/QuartzCore.h>
#import "ShoppingCartCell.h"
@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray *boughtProducts;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"Shopping Cart";
    self.boughtProducts = [NSMutableArray new];
    for(int i = 0;i < self.numProducts.count;i++) {
        if([self.numProducts[i] integerValue] > 0) {
            [self.boughtProducts addObject:self.products[i]];
        }
    }
    self.tableView.tableFooterView = [UIView new]
    ;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boughtProducts.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ShoppingCell";
    
    ShoppingCartCell *cell = (ShoppingCartCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary *product = [self.boughtProducts objectAtIndex:indexPath.row];
    cell.name.text = product[@"name"];
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

@end

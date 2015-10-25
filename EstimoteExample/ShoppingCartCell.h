//
//  ShoppingCartCell.h
//  EstimoteExample
//
//  Created by Vohra, Nikant on 24/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShoppingCellDelegate <NSObject>

-(void)didPressAddButton:(UITableViewCell *)cell;
-(void)didPressSubtractButton:(UITableViewCell *)cell;

@end


@interface ShoppingCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak , nonatomic) id<ShoppingCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end



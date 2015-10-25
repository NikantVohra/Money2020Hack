//
//  ShoppingCartCell.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 24/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonPressed:(id)sender {
    [self.delegate didPressAddButton:self];
}

- (IBAction)removeButtonPressed:(id)sender {
    [self.delegate didPressSubtractButton:self];
}

@end

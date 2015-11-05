//
//  WelcomeNewViewController.m
//  GoCart
//
//  Created by Vohra, Nikant on 25/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "WelcomeNewViewController.h"

@interface WelcomeNewViewController ()<UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImageView;
@property(nonatomic, strong) NSString *isFirstTIme;
@end

@implementation WelcomeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"btnOffGo"]];
    [self.tabBarItem setImage:[UIImage imageNamed:@"btnOffGo"]];

    self.tabBarController.delegate = self;
    self.isFirstTIme = @"YES";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if([[viewController childViewControllers][0] isKindOfClass:[WelcomeNewViewController class]]){
        if([self.isFirstTIme isEqualToString:@"YES"]) {
            self.welcomeImageView.image = [UIImage imageNamed:@"shoping"];
            self.isFirstTIme = @"NO";
            [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"btnOnGo"]];
              [self.tabBarItem setImage:[UIImage imageNamed:@"btnOnGo"]];
        }
        else {
            self.welcomeImageView.image = [UIImage imageNamed:@"shoping2"];
            self.isFirstTIme = @"YES";
            [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"btnOffGo"]];
            [self.tabBarItem setImage:[UIImage imageNamed:@"btnOffGo"]];

        }
    }
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

//
//  ConceirgeViewController.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 25/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "ConceirgeViewController.h"

@interface ConceirgeViewController ()

@end

@implementation ConceirgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                   selector: @selector(sendPosition) userInfo: nil repeats: NO];
}

-(void)sendPosition {
    [self performSegueWithIdentifier:@"rateSegue" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  PromoViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/4/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "PromoViewController.h"

@interface PromoViewController ()

@end

@implementation PromoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get rid of this and fix the bug!
    [_promoImage setImage:[UIImage imageNamed:@"bandwagon"]];   
    [_promoText setText:@"There's nothing like an order of Bandwagon fries, so go enjoy some later on today and display this message for a $1 discount!"];
    [_promoText setTextAlignment:NSTextAlignmentLeft];
    [_promoTitle setText:@"Enjoy some Bandwagon Fries"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

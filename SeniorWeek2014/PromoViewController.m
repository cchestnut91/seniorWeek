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
    
    [self.promoImage setImage:self.image];
    [self.promoText setText:self.message];
    [self.promoTitle setText:self.promoTitleText];
    [self.promoText setTextColor:[UIColor colorWithRed:(252/255.0) green:(185/255.0) blue:(34/255.0) alpha:1]];
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

//
//  PromoViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/4/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *promoTitle;
@property (strong, nonatomic) NSString *promoTitleText;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UITextView *promoText;

@end

//
//  PromoTableViewCell.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/19/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "PromoTableViewCell.h"

@implementation PromoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

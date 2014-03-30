//
//  Help.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/30/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Help : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *answer;

-(id)initWithTitle:(NSString *)titleIn andAnswer:(NSString *)answerIn;

@end

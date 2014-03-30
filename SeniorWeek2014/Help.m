//
//  Help.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/30/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "Help.h"

@implementation Help

@synthesize title, answer;

-(id)initWithTitle:(NSString *)titleIn andAnswer:(NSString *)answerIn{
    self = [super init];
    
    self.title = titleIn;
    self.answer = answerIn;
    
    return self;
}

@end

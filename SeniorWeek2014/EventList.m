//
//  EventList.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/25/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "EventList.h"

@implementation EventList

@synthesize list;

-(id) init {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    
    Event *concert = [[Event alloc] initWithTitle:@"Kickoff Concert" andDate:[formatter dateFromString:@"5/12/2014 9:00 PM"] andEnd:[formatter dateFromString:@"5/13/2014 12:00 AM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"launchConcertImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek1.jpg"] andLocation:[[Location alloc] initWithName:@"Emerson Suites" andAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.422215] andLong:[[NSNumber alloc] initWithFloat:-76.494070]] andInfo:@"Kickoff your last week as a senior with the DJ duo Super Mash Bros and a dance party you will never forget. You’ll want to come ready to dance, wearing white for a highlighter party while we fill Emerson Suites with a state-of-the-art light show. Be sure to start your Senior Week off right with a night you don’t want to miss!" andReqs:@"Must bring two forms of ID" andTransport:@"Bus Picks Up Every 30 Min Starting at 8:45" andAlcohol:@"Cash Bar" andFood:@"Light Snacks"];
    
    Event *drinksOnLake = [[Event alloc] initWithTitle:@"Drinks on the Lake" andDate:[formatter dateFromString:@"5/13/2014 8:00 PM"] andEnd:[formatter dateFromString:@"5/13/2014 11:00 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"drinksOnLakeImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek2.png"] andLocationName:@"LakeWatch Inn" andLocationAddress:@"953 Danby Rd" andLat:[[NSNumber alloc] initWithFloat:42.422215] andLong:[[NSNumber alloc] initWithFloat:-76.494070] andInfo:@"Join your classmates for a night of Drinks on the Lake. Lakewatch Inn is the perfect venue for a classy night of cocktails and hors d’oeuvres for you and all your friends. Musical talents of Virgil Cain. Take the night to dress up and enjoy the evening with your friends and fellow classmates over Cayuga Lake." andReqs:@"Must bring two forms of ID\nMust use provided transportation" andTransport:@"Bus Picks Up Every 30 Min from 7:30 - 11:15" andAlcohol:@"Cash Bar" andFood:@"Scrumptious Desserts"];
    
    Event *wineTourTuesday = [[Event alloc] initWithTitle:@"Wine Tour" andDate:[formatter dateFromString:@"5/13/2014 9:30 AM"] andEnd:[formatter dateFromString:@"5/13/2014 4:00 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"wineTourImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek3.png"] andLocationName:@"Cayuga & Seneca Lake" andLocationAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.424323] andLong:[[NSNumber alloc] initWithFloat:-76.494070] andInfo:@"Cross this one off your bucket list, it’s time to head out on a Finger Lakes wine tour! For an additional low cost, you have the opportunity to hop on the bus for a wine tour of Seneca or Cayuga Lake. Spots are limited, so coordinate with your friends which tour you would like to go on and buy your Senior Week pass early!" andReqs:@"$35 Fee\nMust bring two forms of ID" andTransport:@"Bus Leaves at 9:30 AM" andAlcohol:@"Wine Tastings" andFood:@"None"];
    
    Event *seniorSplash = [[Event alloc] initWithTitle:@"Senior Splash" andDate:[formatter dateFromString:@"5/14/2014 12:00 PM"] andEnd:[formatter dateFromString:@"5/14/2014 3:00 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"splashImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek4.png"] andLocationName:@"Academic Quad" andLocationAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.422215] andLong:[[NSNumber alloc] initWithFloat:-76.495277] andInfo:@"Join us for a day of fun and games on the Fitness Center Quad followed by the most rewarding fountain jump you’ll ever earn! Enjoy a summertime BBQ with inflatables, yard games, and much more, all while the sounds of the Ithaca College Steel Drum Band fill the quad. Be sure to wear your Senior Week t-shirts for when you finally take the plunge into the fountains. Get ready for an afternoon of food, fun, and traditions with your class!" andReqs:@"$20 without Senior Pass" andTransport:@"No Transportation Provided" andAlcohol:@"None" andFood:@"BBQ"];
    
    Event *commonsNight = [[Event alloc] initWithTitle:@"Night on the Commons" andDate:[formatter dateFromString:@"5/14/2014 7:00 PM"] andEnd:[formatter dateFromString:@"5/14/2014 9:00 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"commonsImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek5.png"] andLocationName:@"Ithaca Commons" andLocationAddress:@"E Martin Luther King Jr St, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.439603] andLong:[[NSNumber alloc] initWithFloat: -76.495277] andInfo:@"Dry off from Splash and head downtown because for one night only—the commons are being taken over by the Class of 2014! Join us downtown in the Ithaca Commons for an evening of great food, great drinks, and great friends! Local vendors will be providing food and drinks for everyone to try- including beer and wine tastings! We’ll also have a jazz band performing for your pleasure, and a variety of other activities and entertainment throughout the evening. So, head down to the Commons and enjoy an outdoor party with all your friends!" andReqs:@"Must bring two forms of ID" andTransport:@"No Transportation Provided" andAlcohol:@"Wine & Beer Tastings" andFood:@"Provided"];
    
    Event *wineTourThursday = [[Event alloc] initWithTitle:@"Wine Tour" andDate:[formatter dateFromString:@"5/15/2014 9:30 AM"] andEnd:[formatter dateFromString:@"5/15/2014 4:00 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"wineTourImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek3.png"] andLocationName:@"Cayuga & Seneca Lake" andLocationAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.424323] andLong:[[NSNumber alloc] initWithFloat:-76.494070] andInfo:@"Cross this one off your bucket list, it’s time to head out on a Finger Lakes wine tour! For an additional low cost, you have the opportunity to hop on the bus for a wine tour of Seneca or Cayuga Lake. Spots are limited, so coordinate with your friends which tour you would like to go on and buy your Senior Week pass early!" andReqs:@"$35 Fee\nMust bring two forms of ID" andTransport:@"Bus Leaves at 9:30 AM" andAlcohol:@"Wine Tastings" andFood:@"None"];
    
    Event *formal = [[Event alloc] initWithTitle:@"Senior Class Formal" andDate:[formatter dateFromString:@"5/15/2014 9:00 PM"] andEnd:[formatter dateFromString:@"5/06/2014 1:00 AM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"formalImgA"]] andBanner:[UIImage imageNamed:@"SeniorWeek6.png"] andLocationName:@"Emerson Suites" andLocationAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.422215] andLong:[[NSNumber alloc] initWithFloat:-76.494070]andInfo:@"Get dressed up to the nines and prepare to dance the night away, as it is time for the Senior Class Formal! Join us in Emerson Suites for shimmering lights, upbeat music, and an elegant atmosphere. Be sure not to miss this amazing night of great music, dancing and friends." andReqs:@"Must bring two forms of ID" andTransport:@"Bus Picks Up Every 30 Min Starting at 8:45" andAlcohol:@"Cash bar" andFood:@"Hors d’oeuvres"];
    
    Event *fireworks = [[Event alloc] initWithTitle:@"Commencment Eve Concert" andDate:[formatter dateFromString:@"5/17/2014 8:30 PM"] andEnd:[formatter dateFromString:@"5/17/2014 10:30 PM"] andImages:[NSArray arrayWithObject:[UIImage imageNamed:@"fireworksImgA.png"]] andBanner:[UIImage imageNamed:@"SeniorWeek7.png"] andLocationName:@"A/E Center" andLocationAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.423413] andLong:[[NSNumber alloc] initWithFloat:-76.491305] andInfo:@"Spend the night before graduation with your family attending the Commencement Eve Concert entitled 'RITUAL-and how its music deepens our lives', and see your classmates perform in the A&E Center. After the concert, head outside to see a spectacular fireworks display and take photos with your friends and family. Be sure to spend your last night as an Ithaca College student with some phenomenal performances, photos, and fireworks!" andReqs:@"None" andTransport:@"No Transportation Provided" andAlcohol:@"None" andFood:@"None"];
    
    
    NSArray *monday = [NSArray arrayWithObject:concert];
    NSArray *tuesday = [NSArray arrayWithObjects:wineTourTuesday, drinksOnLake, nil];
    NSArray *wednesday = [NSArray arrayWithObjects:seniorSplash, commonsNight, nil];
    NSArray *thursday = [NSArray arrayWithObjects:wineTourThursday, formal, nil];
    NSArray *saturday = [NSArray arrayWithObject:fireworks];
    
    list = [NSArray arrayWithObjects:monday, tuesday, wednesday, thursday, saturday, nil];
    
    return self;
    
}

-(NSArray *)getList {
    return list;
}

@end

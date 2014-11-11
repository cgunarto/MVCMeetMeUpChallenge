//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#define kURLSearcStringForEvent @"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=41c4c15142b5d1f27d5e666e4b1e44"

@implementation Event
@class Event;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

//Retrieve event from search string and returns an array with custom event objects
+ (void)retrieveEventsWithString:(NSString *)keyword andCompletion:(void(^)(NSArray *eventObjectsArray, NSError *error))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kURLSearcStringForEvent,keyword]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSError *JSONError = nil;

                               if (!connectionError)
                               {
                                   NSArray *eventDictionariesArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&JSONError] objectForKey:@"results"];
                                   if (!JSONError)
                                   {
                                       NSArray *eventObjectsArray = [Event eventsFromArray:eventDictionariesArray];
                                       complete (eventObjectsArray, connectionError);
                                   }

                                   else
                                   {
                                       complete (nil,JSONError);
                                   }
                               }

                               else
                               {
                                   complete (nil,connectionError);
                               }
                           }];
}

//MARK:Helper Method
//Helper method to taken an incoming array with dictionary objects and return it into an array with custom event object
+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

//Helper method that takes NSString of photoURL and returns and NSData
- (void)retrieveImageWithCompletion:(void(^)(NSData *imageData, NSError *error))complete
{
    NSURLRequest *imageReq = [NSURLRequest requestWithURL:self.photoURL];

    [NSURLConnection sendAsynchronousRequest:imageReq
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if (!connectionError)
            {
                complete(data, connectionError);
            }

            else
            {
                complete(nil, connectionError);
            }
        });
    }];
}





@end

//
//  Comment.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Comment.h"
#define kURLEventIDforComments @"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=41c4c15142b5d1f27d5e666e4b1e44"

@implementation Comment


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.author = dictionary[@"member_name"];
        self.date = [Comment dateFromNumber:dictionary[@"time"]];
        self.text = dictionary[@"comment"];
        self.memberID = dictionary[@"member_id"];
    }
    return self;
}

+ (void)retrieveCommentsWithEventIDString:(NSString *)eventID andCompletion:(void(^)(NSArray* commentObjectsArray, NSError *error))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kURLEventIDforComments,eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                            {
                               NSError *JSONError = nil;

                               if (!connectionError)
                               {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONError];
                                   NSArray *jsonArray = [dict objectForKey:@"results"];

                                   if (!JSONError)
                                   {
                                       NSArray *commentObjectsArray = [Comment objectsFromArray:jsonArray];
                                       complete(commentObjectsArray, connectionError);
                                   }
                                   else
                                   {
                                       complete(nil,JSONError);
                                   }
                               }
                               else
                               {
                                   complete(nil,connectionError);
                               }
                           }];

}

//MARK: Helper Method
//Takes an array of dictionary objects and returns an array of Comment objects
+ (NSArray *)objectsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];

    for (NSDictionary *d in incomingArray) {
        Comment *e = [[Comment alloc]initWithDictionary:d];
        [newArray addObject:e];

    }
    return newArray;
}

//Changes timestamp into NSDate
+ (NSDate *) dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue] )];
    NSTimeInterval interval = [time doubleValue];
    return  [NSDate dateWithTimeIntervalSince1970:interval];

}


@end

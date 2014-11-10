//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#define kURLRetrieveMemberfromID @"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=41c4c15142b5d1f27d5e666e4b1e44"

@implementation Member

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
    }
    return self;
}

+ (void)retrieveEventsWithMemberIDString:(NSString *)memberID andCompletion:(void(^)(Member *member, NSError *error))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kURLRetrieveMemberfromID,memberID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSError *JSONError = nil;

                               if (!connectionError)
                               {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                                   if (!JSONError)
                                   {
                                       Member *member = [[Member alloc] initWithDictionary:dict];

                                       complete (member, connectionError);
                                   }
                                   else
                                   {
                                       complete (nil,JSONError);
                                   }
                               }
                               else
                               {
                                   complete (nil, connectionError);
                               }
                           }];
}

- (void)retrieveImageWithCompletion:(void(^)(NSData *imageData, NSError *error))complete
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
            if (!connectionError)
            {
                complete(data,connectionError);
            }
            else
            {
                complete(nil,connectionError);
            }
        }];
}




@end

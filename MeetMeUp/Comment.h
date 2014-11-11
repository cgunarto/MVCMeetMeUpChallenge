//
//  Comment.h
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *text;

+ (void)retrieveCommentsWithEventIDString:(NSString *)eventID andCompletion:(void(^)(NSArray* commentObjectsArray, NSError *error))complete;
+ (NSArray *)objectsFromArray:(NSArray *)incomingArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

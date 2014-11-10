//
//  CommentsTableViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "MemberViewController.h"
#import "CommentTableViewCell.h"
#import "CommentsTableViewController.h"

@interface CommentsTableViewController ()

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation CommentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=41c4c15142b5d1f27d5e666e4b1e44",self.event.eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               NSArray *jsonArray = [dict objectForKey:@"results"];

                               self.dataArray = [Comment objectsFromArray:jsonArray];
                               [self.tableView reloadData];
                           }];

    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    Comment *c = self.dataArray[indexPath.row];
    cell.authorLabel.text = c.author;
    cell.commentLabel.text = c.text;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:c.date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MemberViewController *memberVC = [segue destinationViewController];

    Comment *comment = self.dataArray[[self.tableView indexPathForSelectedRow].row];
    memberVC.memberID = comment.memberID;
}


@end

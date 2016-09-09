//
//  ToDoListTableViewController.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/10/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "AppDelegate.h"
#import "NSString+ComponentsLimit.h"
#import "SocketConnection.h"
#import "Channel.h"
#import "ChannelsList.h"

@interface ToDoListTableViewController ()

@end

@implementation ToDoListTableViewController

SocketConnection *conn;
MSCSendMessageCompleteBlock callback;
NSMutableDictionary *channels;
NSMutableArray *channelsMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);

    [self setNeedsStatusBarAppearanceUpdate];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshPrograms)
                  forControlEvents:UIControlEventValueChanged];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    conn = appDelegate.conn;
    
    channels = [ChannelsList getChannels];
    channelsMap = [ChannelsList getChannelsMap];

    [self refreshPrograms];
}

-(void)refreshPrograms {
    
    callback = ^(BOOL wasSuccessful, NSString *lastMessageSent, NSString *response) {
        if (wasSuccessful) {
            if ([lastMessageSent isEqual:@"query liveTV\n"]) {
                
                [self.refreshControl endRefreshing];
                
                NSMutableArray *data = [[response componentsSeparatedByString:@"\r\n"] mutableCopy];
                
                for (int i = 0; i < [data count]; i++)
                {
                    
                    NSString *trimmedString = [[data objectAtIndex: i] stringByTrimmingCharactersInSet:
                                               [NSCharacterSet whitespaceCharacterSet]];
                    
                    NSArray *item = [[trimmedString componentsSeparatedByString: @" " limit:3] mutableCopy];
                    
                    if ([item count] != 4) {
                        continue;
                    }
                    
                    Channel *channel = [channels objectForKey:item[0]];
                    channel.program = item[3];
                    
                }
                
                [self.tableView numberOfRowsInSection:0];
                [self.tableView reloadData];
            }
            
        } else {
            
        }
    };
    
    [conn sendMessage:@"query liveTV\n" withCallback:callback];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [channelsMap count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *mythId = [channelsMap objectAtIndex:indexPath.row];
    Channel *channel = [channels objectForKey:mythId];
    if ([channel.name isEqualToString:channel.callsign]) {
        cell.textLabel.text = channel.name;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", channel.callsign, channel.name];
    }
    
    cell.detailTextLabel.text = channel.program;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *mythId = [channelsMap objectAtIndex:indexPath.row];
    
    [conn sendMessage:[NSString stringWithFormat:@"play chanid %@\n", mythId]];
    
}

@end

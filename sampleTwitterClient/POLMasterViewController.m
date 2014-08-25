//
//  POLViewController.m
//  sampleTwitterClient
//
//  Created by legionpro on 8/25/14.
//  Copyright (c) 2014 Oleh Poremskyy. All rights reserved.
//

#import "POLMasterViewController.h"
#import "POLDetailViewController.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

#define kURLSTRING @"https://api.twitter.com/1.1/statuses/user_timeline.json"
#define kPARAMCOUNT @"100"
#define kPARAMCOUNT1 @"1"
#define kPARAMKEY @"count"
#define kPARAMKEY1 @"include_entities"

@implementation POLMasterViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTweet"]) {
        NSDictionary *tweet = [tweets objectAtIndex:[[self tableView].indexPathForSelectedRow row]];
        POLDetailViewController *detailController = segue.destinationViewController;
        detailController.detailItem = tweet;
    }
}


- (void)handleRefresh:(id)sender
{
    [self  fetchTweets];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)fetchTweets
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        ACAccountStore *account = [[ACAccountStore alloc] init]; // Creates AccountStore object.
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES){
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 if ([arrayOfAccounts count] > 0) {
                     ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                     NSURL *requestAPI = [NSURL URLWithString:kURLSTRING];
                     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                     [parameters setObject:kPARAMCOUNT forKey:kPARAMKEY];
                     [parameters setObject:kPARAMCOUNT1 forKey:kPARAMKEY1];
                     SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                     posts.account = twitterAccount;
                     [posts performRequestWithHandler:
                      ^(NSData *response, NSHTTPURLResponse
                        *urlResponse, NSError *error)
                      {
                          if(response){
                              tweets = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.tableView reloadData];
                                  [self.refreshControl endRefreshing];
                              });
                          }else{
                              //no data returned
                          }
                      }];
                 }
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.refreshControl endRefreshing];
                 });
             }
         }];
    }else{
        [self.refreshControl endRefreshing];
    }
}


- (IBAction)addNewTweet:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                //NSLog(@"Cancelled");
            } else
            {
                [self  fetchTweets];
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        [controller setInitialText:@""];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else{
        [self.refreshControl endRefreshing];
        //NSLog(@"not available");
    }
    
}

#pragma mark - TABLEView lifecycle

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =  @"cell" ;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *tweet = tweets[indexPath.row];
    cell.textLabel.text = tweet[@"text"];
    NSString *text = [tweet objectForKey:@"text"];
    NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", name];
    return cell;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


//
//  POLViewController.h
//  sampleTwitterClient
//
//  Created by legionpro on 8/25/14.
//  Copyright (c) 2014 Oleh Poremskyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POLMasterViewController : UITableViewController{
    NSArray *tweets;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTweetButton;

- (void)fetchTweets;
- (IBAction)addNewTweet:(id)sender;

@end

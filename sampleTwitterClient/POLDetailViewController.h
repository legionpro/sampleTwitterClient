//
//  POLDetailViewController.h
//  sampleTwitterClient
//
//  Created by legionpro on 8/25/14.
//  Copyright (c) 2014 Oleh Poremskyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POLDetailViewController : UIViewController {
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *nameLabel;
    __weak IBOutlet UITextView *tweetText;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
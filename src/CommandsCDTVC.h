//
//  ViewController.h
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"

@interface CommandsCDTVC : UITableViewController<GoogleNowCardViewDelegate>

@property NSArray *commands;  // of Command

@end

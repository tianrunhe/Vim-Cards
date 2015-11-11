//
//  CommandSearchResultsTableViewController.h
//  Vim Cards
//
//  Created by Runhe Tian on 11/10/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleNowCardView.h"

@interface CommandSearchResultsTableViewController
    : UITableViewController<GoogleNowCardViewDelegate>

@property(nonatomic, strong) NSMutableArray *filteredCommands;

@end

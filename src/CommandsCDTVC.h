//
//  ViewController.h
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GoogleNowCardView.h"

@interface CommandsCDTVC : UITableViewController<GoogleNowCardViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController
    *fetchedResultsController;

- (void)performFetch;

// Set to YES to get some debugging output in the console.
@property BOOL debug;

@end


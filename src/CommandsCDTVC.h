//
//  ViewController.h
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"
#import "CoreDataTableViewController.h"

@interface CommandsCDTVC
    : CoreDataTableViewController<GoogleNowCardViewDelegate,
                                  UISearchBarDelegate, UISearchResultsUpdating>

@property(nonatomic, strong) UISearchController *searchController;

@end

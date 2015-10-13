//
//  CommandSearchViewController.h
//  Vim Cards
//
//  Created by Runhe Tian on 10/11/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandsCDTVC.h"

@interface CommandSearchViewController
    : UIViewController<UISearchBarDelegate, UISearchResultsUpdating>

@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) CommandsCDTVC *commandsCDTVC;

- (id)initWithFetchedResultsController:
    (NSFetchedResultsController *)fetchedResultsController;

@end

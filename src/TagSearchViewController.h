//
//  CategoryTableViewController.h
//  Vim Cards
//
//  Created by Runhe Tian on 10/15/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsCDTVC.h"

@interface TagSearchViewController
    : UIViewController<UISearchControllerDelegate, UISearchResultsUpdating>

@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) TagsCDTVC *tagsCDTVC;

- (id)initWithFetchedResultsController:
    (NSFetchedResultsController *)fetchedResultsController;

@end
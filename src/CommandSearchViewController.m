//
//  CommandSearchViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/11/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandSearchViewController.h"

@interface CommandSearchViewController ()

@end

@implementation CommandSearchViewController

- (id)initWithFetchedResultsController:
    (NSFetchedResultsController *)fetchedResultsController {
  self = [super init];
  if (self) {
    _searchController =
        [[UISearchController alloc] initWithSearchResultsController:nil];
    _commandsCDTVC =
        [[CommandsCDTVC alloc] initWithStyle:UITableViewStylePlain];
    _commandsCDTVC.debug = YES;
    _commandsCDTVC.fetchedResultsController = fetchedResultsController;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _searchController.searchResultsUpdater = self;
  _searchController.dimsBackgroundDuringPresentation = NO;
  _searchController.hidesNavigationBarDuringPresentation = NO;
  UIApplication *application = [UIApplication sharedApplication];
  _searchController.searchBar.frame = CGRectMake(
      self.view.frame.origin.x,
      self.view.frame.origin.y + application.statusBarFrame.size.height,
      self.view.frame.size.width, 44.0);
  _searchController.searchBar.delegate = self;

  _commandsCDTVC.tableView.frame = CGRectMake(
      self.view.frame.origin.x,
      self.view.frame.origin.y + application.statusBarFrame.size.height + 44,
      self.view.frame.size.width, self.view.frame.size.height - 44);

  [self.view addSubview:_searchController.searchBar];
  [self.view addSubview:_commandsCDTVC.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
  NSString *searchString = [self.searchController.searchBar text];
  [self updateTableViewWithSearchString:searchString];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self updateTableViewWithSearchString:@""];
}

- (void)updateTableViewWithSearchString:(NSString *)keyword {
  if (![keyword length]) {
    _commandsCDTVC.fetchedResultsController.fetchRequest.predicate =
        [NSPredicate predicateWithValue:YES];
  } else {
    NSPredicate *commandContentPredicate =
        [NSPredicate predicateWithFormat:@"content CONTAINS[cd] %@", keyword];
    NSPredicate *tagNamePredicate =
        [NSPredicate predicateWithFormat:@"tags.name CONTAINS[cd] %@", keyword];
    _commandsCDTVC.fetchedResultsController.fetchRequest.predicate =
        [NSCompoundPredicate
            orPredicateWithSubpredicates:
                @[ commandContentPredicate, tagNamePredicate ]];
  }
  [_commandsCDTVC performFetch];
  [_commandsCDTVC.tableView reloadData];
}

@end

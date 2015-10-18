//
//  CategoryTableViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/15/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "TagSearchViewController.h"
#import "Tag.h"

@interface TagSearchViewController ()

@end

@implementation TagSearchViewController

- (id)initWithFetchedResultsController:
    (NSFetchedResultsController *)fetchedResultsController {
  self = [super init];

  if (self) {
    _searchController =
        [[UISearchController alloc] initWithSearchResultsController:nil];
    _tagsCDTVC = [[TagsCDTVC alloc] initWithStyle:UITableViewStylePlain];
    _tagsCDTVC.debug = YES;
    _tagsCDTVC.fetchedResultsController = fetchedResultsController;

    self.title = @"Categories";
    self.tabBarItem = [[UITabBarItem alloc]
        initWithTabBarSystemItem:UITabBarSystemItemBookmarks
                             tag:1];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIApplication *application = [UIApplication sharedApplication];
  self.view.frame = CGRectMake(
      self.view.frame.origin.x,
      self.view.frame.origin.y + application.statusBarFrame.size.height,
      self.view.frame.size.width,
      self.view.frame.size.height - application.statusBarFrame.size.height);

  _searchController.searchResultsUpdater = self;
  _searchController.dimsBackgroundDuringPresentation = NO;

  CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                            self.view.frame.size.width, 44.0);
  UIView *searchBarViewContainer = [[UIView alloc] initWithFrame:frame];
  _searchController.searchBar.translucent = NO;
  searchBarViewContainer.clipsToBounds = YES;
  [searchBarViewContainer addSubview:_searchController.searchBar];
  _searchController.delegate = self;

  _tagsCDTVC.tableView.frame =
      CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44,
                 self.view.frame.size.width, self.view.frame.size.height - 44);

  [self.view addSubview:searchBarViewContainer];
  [self.view addSubview:_tagsCDTVC.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

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
    _tagsCDTVC.fetchedResultsController.fetchRequest.predicate =
        [NSPredicate predicateWithValue:YES];
  } else {
    NSPredicate *tagNamePredicate =
        [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", keyword];
    _tagsCDTVC.fetchedResultsController.fetchRequest.predicate =
        tagNamePredicate;
  }
  [_tagsCDTVC performFetch];
}

@end

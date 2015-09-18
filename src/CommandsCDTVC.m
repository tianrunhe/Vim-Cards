//
//  ViewController.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "CommandsCDTVC.h"
#import "GoogleNowCardView.h"
#import "Command.h"

@implementation CommandsCDTVC

#define ROW_HEIGHT 200  // dp

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"VIM Command Cell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  CGRect frame =
      CGRectMake(self.view.frame.origin.x,
                 self.view.frame.origin.y + ROW_HEIGHT - SPACE_BETWEEN_CARDS,
                 self.view.frame.size.width, ROW_HEIGHT - SPACE_BETWEEN_CARDS);
  GoogleNowCardView *cardView = cell.contentView.subviews[0];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    cardView = [[GoogleNowCardView alloc] initWithFrame:frame];
  }

  Command *command =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  cardView.primaryText = command.title;
  cardView.subtitleText = command.content;
  [cell.contentView addSubview:cardView];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return ROW_HEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView
    shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _searchController =
      [[UISearchController alloc] initWithSearchResultsController:nil];
  _searchController.searchResultsUpdater = self;
  _searchController.dimsBackgroundDuringPresentation = NO;
  _searchController.hidesNavigationBarDuringPresentation = NO;
  _searchController.searchBar.frame =
      CGRectMake(self.searchController.searchBar.frame.origin.x,
                 self.searchController.searchBar.frame.origin.y,
                 self.searchController.searchBar.frame.size.width, 44.0);
  self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - GoogleNowCardViewDelegate

- (void)shareButtonDidPressed {
  NSMutableArray *sharingItems = [NSMutableArray new];

  [sharingItems addObject:@"Hi"];
  [sharingItems addObject:[UIImage imageNamed:@"favorite"]];
  [sharingItems addObject:[NSURL URLWithString:@"www.google.com"]];

  UIActivityViewController *activityController =
      [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                        applicationActivities:nil];
  [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
  NSString *searchString = [self.searchController.searchBar text];

  self.fetchedResultsController.fetchRequest.predicate = [NSPredicate
      predicateWithFormat:@"content CONTAINS[cd] %@", searchString];
  [self performFetch];
  [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  UISearchBar *searchBar = self.searchController.searchBar;
  CGRect rect = searchBar.frame;
  rect.origin.y = MIN(0, scrollView.contentOffset.y);
  searchBar.frame = rect;
}

@end
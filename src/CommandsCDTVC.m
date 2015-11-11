//
//  ViewController.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "CommandsCDTVC.h"
#import "CommandSearchResultsTableViewController.h"
#import "GoogleNowCardView.h"
#import "Command.h"
#import "CommandsData.h"
#import "Tag.h"

@interface CommandsCDTVC ()<UISearchResultsUpdating>

@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation CommandsCDTVC

#define ROW_HEIGHT 200  // dp

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"Search";
    self.tabBarItem =
        [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch
                                                   tag:1];
  }
  return self;
}

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
  cardView.delegate = self;
  cardView.shareable = YES;
  cardView.likeable = YES;

  Command *command = [_commands objectAtIndex:indexPath.row];
  cardView.primaryText = command.title;
  cardView.subtitleText = command.content;
  cardView.isFavorite = [command.favorite boolValue];

  [cell.contentView addSubview:cardView];

  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [_commands count];
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

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.scrollsToTop = YES;

  UINavigationController *searchResultsController =
      [[UINavigationController alloc]
          initWithRootViewController:
              [[CommandSearchResultsTableViewController alloc] init]];

  // Our instance of UISearchController will use searchResults
  self.searchController = [[UISearchController alloc]
      initWithSearchResultsController:searchResultsController];

  // The searchcontroller's searchResultsUpdater property will contain our
  // tableView.
  self.searchController.searchResultsUpdater = self;

  // The searchBar contained in XCode's storyboard is a leftover from
  // UISearchDisplayController.
  // Don't use this. Instead, we'll create the searchBar programatically.

  self.searchController.searchBar.frame =
      CGRectMake(self.searchController.searchBar.frame.origin.x,
                 self.searchController.searchBar.frame.origin.y,
                 self.searchController.searchBar.frame.size.width, 44.0);

  self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - GoogleNowCardViewDelegate

- (void)shareButtonDidPressed:(NSString *)content {
  NSMutableArray *sharingItems = [NSMutableArray new];
  [sharingItems addObject:content];
  UIActivityViewController *activityController =
      [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                        applicationActivities:nil];
  [self presentViewController:activityController animated:YES completion:nil];
}

- (void)favoriteButtonDidPressed:(id)sender {
  GoogleNowCardView *cardView = (GoogleNowCardView *)sender;
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"title = %@", cardView.primaryText];
  Command *command =
      [[_commands filteredArrayUsingPredicate:predicate] firstObject];
  command.favorite =
      [NSNumber numberWithLong:1L - command.favorite.longLongValue];
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
  // Set searchString equal to what's typed into the searchbar
  NSString *searchString = self.searchController.searchBar.text;

  [self updateFilteredContentForKeyword:searchString];

  // If searchResultsController
  if (self.searchController.searchResultsController) {
    UINavigationController *navController =
        (UINavigationController *)self.searchController.searchResultsController;

    // Present SearchResultsTableViewController as the topViewController
    CommandSearchResultsTableViewController *vc =
        (CommandSearchResultsTableViewController *)
            navController.topViewController;

    // Update searchResults
    vc.filteredCommands = self.searchResults;

    // And reload the tableView with the new data
    [vc.tableView reloadData];
  }
}

// Update self.searchResults based on searchString, which is the argument in
// passed to this method
- (void)updateFilteredContentForKeyword:(NSString *)keyword {
  if (keyword == nil || !keyword.length) {
    self.searchResults = [[CommandsData instance].commands mutableCopy];
  } else {
    NSPredicate *predicate;
    NSArray *candidates;
    if (![keyword length]) {
      predicate = [NSPredicate predicateWithValue:YES];
      candidates = [[CommandsData instance]
                        .commands filteredArrayUsingPredicate:predicate];
    } else {
      NSPredicate *commandTitlePredicate =
          [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", keyword];
      NSPredicate *commandContentPredicate =
          [NSPredicate predicateWithFormat:@"content CONTAINS[cd] %@", keyword];
      NSPredicate *tagNamePredicate = [NSPredicate
          predicateWithFormat:@"tags.name CONTAINS[cd] %@", keyword];
      predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[
        commandTitlePredicate,
        commandContentPredicate,
        tagNamePredicate
      ]];
      candidates = [[[CommandsData instance]
                         .commands filteredArrayUsingPredicate:predicate]
          sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1,
                                                         id _Nonnull obj2) {
            Command *command1 = (Command *)obj1;
            Command *command2 = (Command *)obj2;

            NSInteger score1 = 0;
            NSInteger score2 = 0;
            if ([command1.title caseInsensitiveCompare:keyword] ==
                NSOrderedSame) {
              score1 += 100;
            } else if ([command1.title rangeOfString:keyword
                                             options:NSCaseInsensitiveSearch]
                           .location != NSNotFound) {
              score1 += 5;
            }
            if ([command1.content caseInsensitiveCompare:keyword] ==
                NSOrderedSame) {
              score1 += 50;
            } else if ([command1.content rangeOfString:keyword
                                               options:NSCaseInsensitiveSearch]
                           .location != NSNotFound) {
              score1 += 3;
            }

            if ([command2.title caseInsensitiveCompare:keyword] ==
                NSOrderedSame) {
              score2 += 100;
            } else if ([command2.title rangeOfString:keyword
                                             options:NSCaseInsensitiveSearch]
                           .location != NSNotFound) {
              score2 += 5;
            }
            if ([command2.content caseInsensitiveCompare:keyword] ==
                NSOrderedSame) {
              score2 += 50;
            } else if ([command2.content rangeOfString:keyword
                                               options:NSCaseInsensitiveSearch]
                           .location != NSNotFound) {
              score2 += 3;
            }

            if (score1 < score2) {
              return NSOrderedDescending;
            } else if (score1 > score2) {
              return NSOrderedAscending;
            } else {
              return NSOrderedSame;
            }

          }];
    }
    self.searchResults = [candidates mutableCopy];
  }
}

@end
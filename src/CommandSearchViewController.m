//
//  CommandSearchViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/11/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandSearchViewController.h"
#import "Command.h"
#import "Tag.h"
#import "NSString+Levenshtein.h"

@interface CommandSearchViewController ()

@end

@implementation CommandSearchViewController

- (id)initWithCommands:(NSArray *)commands {
  self = [super init];

  if (self) {
    _searchController =
        [[UISearchController alloc] initWithSearchResultsController:nil];

    _commandsCDTVC = [[CommandsCDTVC alloc] init];
    _commandsCDTVC.commands = commands;
    self.title = @"Search";
    self.tabBarItem =
        [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch
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

  _commandsCDTVC.tableView.frame =
      CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44,
                 self.view.frame.size.width, self.view.frame.size.height - 44);

  [self.view addSubview:searchBarViewContainer];
  [self.view addSubview:_commandsCDTVC.tableView];
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
  // sort list
  _commandsCDTVC.commands = [_commandsCDTVC.commands
      sortedArrayUsingComparator:(NSComparator) ^ (id obj1, id obj2) {
        Command *command1 = (Command *)obj1;
        Command *command2 = (Command *)obj2;
        NSInteger score1 = [keyword compareWithString:command1.title
                                            matchGain:10
                                          missingCost:1];
        score1 += [keyword compareWithString:command1.description
                                   matchGain:10
                                 missingCost:1];
        for (Tag *tag in command1.tags) {
          score1 +=
              [keyword compareWithString:tag.name matchGain:10 missingCost:1];
        }

        NSInteger score2 = [keyword compareWithString:command2.title
                                            matchGain:10
                                          missingCost:1];
        score2 += [keyword compareWithString:command2.description
                                   matchGain:10
                                 missingCost:1];
        for (Tag *tag in command2.tags) {
          score2 +=
              [keyword compareWithString:tag.name matchGain:10 missingCost:1];
        }
        if (score1 > score2) {
          return NSOrderedDescending;
        } else if (score1 < score2) {
          return NSOrderedAscending;
        } else {
          return NSOrderedSame;
        }
      }];
  [_commandsCDTVC.tableView reloadData];
}

@end

//
//  CommandSearchViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/11/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandSearchViewController.h"
#import "Command.h"
#import "CommandsData.h"
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
    NSPredicate *tagNamePredicate =
        [NSPredicate predicateWithFormat:@"tags.name CONTAINS[cd] %@", keyword];
    predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[
      commandTitlePredicate,
      commandContentPredicate,
      tagNamePredicate
    ]];
    candidates = [
        [[CommandsData instance].commands filteredArrayUsingPredicate:predicate]
        sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1,
                                                       id _Nonnull obj2) {
          Command *command1 = (Command *)obj1;
          Command *command2 = (Command *)obj2;
          //          NSInteger score1 = [keyword
          //          compareWithString:command1.title
          //                                              matchGain:10
          //                                            missingCost:1];
          //          score1 += [keyword compareWithString:command1.description
          //                                     matchGain:10
          //                                   missingCost:3];
          //          for (Tag *tag in command1.tags) {
          //            score1 +=
          //                [keyword compareWithString:tag.name matchGain:10
          //                missingCost:1];
          //          }
          //
          //          NSInteger score2 = [keyword
          //          compareWithString:command2.title
          //                                              matchGain:7
          //                                            missingCost:2];
          //          score2 += [keyword compareWithString:command2.description
          //                                     matchGain:5
          //                                   missingCost:1];
          //          for (Tag *tag in command2.tags) {
          //            score2 +=
          //                [keyword compareWithString:tag.name matchGain:10
          //                missingCost:1];
          //          }
          //          if (score1 > score2) {
          //            return NSOrderedDescending;
          //          } else if (score1 < score2) {
          //            return NSOrderedAscending;
          //          } else {
          //            return NSOrderedSame;
          //          }
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
  _commandsCDTVC.commands = candidates;
  [_commandsCDTVC.tableView reloadData];
}
@end

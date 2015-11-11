//
//  CommandSearchResultsTableViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 11/10/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandSearchResultsTableViewController.h"
#import "GoogleNowCardView.h"
#import "Command.h"
#import "CommandsData.h"
#import "Tag.h"

@implementation CommandSearchResultsTableViewController

#define ROW_HEIGHT 200  // dp

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.filteredCommands count];
}

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

  Command *command = [_filteredCommands objectAtIndex:indexPath.row];
  cardView.primaryText = command.title;
  cardView.subtitleText = command.content;
  cardView.isFavorite = [command.favorite boolValue];

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
      [[_filteredCommands filteredArrayUsingPredicate:predicate] firstObject];
  command.favorite =
      [NSNumber numberWithLong:1L - command.favorite.longLongValue];
}
@end

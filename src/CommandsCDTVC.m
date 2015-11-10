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
#import "Tag.h"

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

- (void)favoriteButtonDidPressed:(id)sender {
  GoogleNowCardView *cardView = (GoogleNowCardView *)sender;
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"title = %@", cardView.primaryText];
  Command *command =
      [[_commands filteredArrayUsingPredicate:predicate] firstObject];
  command.favorite =
      [NSNumber numberWithLong:1L - command.favorite.longLongValue];
}

@end
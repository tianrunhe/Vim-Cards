//
//  TagsCDTVCViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/18/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "TagsCDTVC.h"
#import "GoogleNowCardView.h"
#import "Tag.h"
#import "CommandsData.h"
#import "CommandSearchViewController.h"

@implementation TagsCDTVC

#define ROW_HEIGHT 150  // dp

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"VIM Command Tag Cell";
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
  [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                             action:@selector(cellTapped:)]];
  cardView.shareable = NO;
  cardView.likeable = NO;
  cardView.tags = @[];

  Tag *tag = [_tags objectAtIndex:indexPath.row];
  cardView.primaryText = tag.name;
  cardView.subtitleText = [NSString
      stringWithFormat:@"%@ commands",
                       [NSNumber numberWithInteger:tag.commands.count]];
  [cell.contentView addSubview:cardView];

  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [_tags count];
}

#pragma mark - UITableViewDelegate

- (void)cellTapped:(UITapGestureRecognizer *)gr {
  GoogleNowCardView *card = (GoogleNowCardView *)gr.view;
  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"tags.name CONTAINS[cd] %@", card.primaryText];

  CommandsCDTVC *commandsCDTVC =
      [[CommandsCDTVC alloc] initWithStyle:UITableViewStylePlain];
  commandsCDTVC.commands =
      [[CommandsData instance].commands filteredArrayUsingPredicate:predicate];
  commandsCDTVC.title = [NSString
      stringWithFormat:@"%@ (%@)", card.primaryText, card.subtitleText];

  [self.navigationController pushViewController:commandsCDTVC animated:YES];
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

- (void)shareButtonDidPressed:(id)sender {
}

- (void)favoriteButtonDidPressed:(id)sender {
}

@end

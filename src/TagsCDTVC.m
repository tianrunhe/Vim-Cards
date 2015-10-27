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

  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cardView.primaryText = tag.name;
  cardView.subtitleText = [NSString
      stringWithFormat:@"%@ commands",
                       [NSNumber numberWithInteger:tag.commands.count]];
  [cell.contentView addSubview:cardView];

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)cellTapped:(UITapGestureRecognizer *)gr {
  GoogleNowCardView *card = (GoogleNowCardView *)gr.view;
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate = [NSPredicate
      predicateWithFormat:@"tags.name CONTAINS[cd] %@", card.primaryText];
  request.sortDescriptors = @[
    [NSSortDescriptor
        sortDescriptorWithKey:@"title"
                    ascending:YES
                     selector:@selector(localizedStandardCompare:)]
  ];

  NSFetchedResultsController *fetchedResultsController = [
      [NSFetchedResultsController alloc]
      initWithFetchRequest:request
      managedObjectContext:self.fetchedResultsController.managedObjectContext
        sectionNameKeyPath:nil
                 cacheName:nil];
  CommandsCDTVC *commandsCDTVC =
      [[CommandsCDTVC alloc] initWithStyle:UITableViewStylePlain];
  commandsCDTVC.debug = YES;
  commandsCDTVC.fetchedResultsController = fetchedResultsController;
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
}

@end

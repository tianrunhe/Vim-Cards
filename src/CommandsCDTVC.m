//
//  ViewController.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "CommandsCDTVC.h"
#import "CommandCardView.h"
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
  CommandCardView *cardView = cell.contentView.subviews[0];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    cardView = [[CommandCardView alloc] initWithFrame:frame];
  }

  NSDictionary *dict = [[NSDictionary alloc]
      initWithObjectsAndKeys:@"A command that moves the "
                             @"cursor.\nExamples:\n  w		to "
                             @"start of next word\n  b		to "
                             @"begin of current word\n  4j		"
                             @"four lines down\n  /The<CR>	to next "
                             @"occurrence of \"The\"",
                             @"{motion}", nil];
  cardView.notations = dict;

  cardView.delegate = self;
  cardView.shareable = YES;
  cardView.likeable = YES;

  Command *command =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  cardView.primaryText = command.title;
  cardView.subtitleText = command.content;
  cardView.isFavorite = [command.favorite boolValue];

  NSMutableArray *tagNames = [[NSMutableArray alloc] init];
  for (Tag *tag in command.tags) {
    [tagNames addObject:tag.name];
  }
  cardView.tags = tagNames;
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
  Command *command = nil;
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate =
      [NSPredicate predicateWithFormat:@"title = %@", cardView.primaryText];

  NSError *error;
  NSArray *matches = [self.fetchedResultsController.managedObjectContext
      executeFetchRequest:request
                    error:&error];

  if (!matches || error || ([matches count] > 1)) {
    // handle error
  } else if ([matches count]) {
    command = [matches firstObject];
    [command setFavorite:[NSNumber numberWithBool:cardView.isFavorite]];
  } else {
    // Not exist?!
  }
  [self.fetchedResultsController.managedObjectContext save:NULL];
  [self performFetch];
}

@end
//
//  FavoriteCommandSearchViewController.m
//  Vim Cards
//
//  Created by Runhe Tian on 11/8/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "FavoriteCommandSearchViewController.h"
#import "CommandsData.h"
#import "Command.h"

@interface FavoriteCommandSearchViewController ()

@end

@implementation FavoriteCommandSearchViewController

- (id)init {
  NSPredicate *globalPredicate =
      [NSPredicate predicateWithFormat:@"favorite=1"];
  self =
      [super initWithCommands:[[CommandsData instance]
                                      .commands
                                  filteredArrayUsingPredicate:globalPredicate]];

  if (self) {
    self.title = @"Favorite";
    self.tabBarItem = [[UITabBarItem alloc]
        initWithTabBarSystemItem:UITabBarSystemItemFavorites
                             tag:1];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.commandsCDTVC.commands = [[CommandsData instance]
                                     .commands
      filteredArrayUsingPredicate:[NSPredicate
                                      predicateWithFormat:@"favorite=1"]];
  [self.commandsCDTVC.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

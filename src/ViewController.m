//
//  ViewController.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "ViewController.h"
#import "GoogleNowCardView.h"
#import "Command.h"

@implementation ViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VIM Command Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        CGRect frame = CGRectMake(self.view.frame.origin.x,
                                  self.view.frame.origin.y +
                                    150 - SPACE_BETWEEN_CARDS,
                                  self.view.frame.size.width,
                                    150 - SPACE_BETWEEN_CARDS);
        GoogleNowCardView *cardView = [[GoogleNowCardView alloc] initWithFrame:frame];

        cardView.primaryText = @"Primary Text";
        cardView.subtitleText = @"Subtitle text";
        [cell.contentView addSubview:cardView];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GoogleNowCardViewDelegate

- (void)shareButtonDidPressed
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:@"Hi"];
    [sharingItems addObject:[UIImage imageNamed:@"favorite"]];
    [sharingItems addObject:[NSURL URLWithString:@"www.google.com"]];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end

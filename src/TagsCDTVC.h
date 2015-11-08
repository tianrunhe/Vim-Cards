//
//  TagsCDTVCViewController.h
//  Vim Cards
//
//  Created by Runhe Tian on 10/18/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"

@interface TagsCDTVC : UITableViewController<GoogleNowCardViewDelegate>

@property NSArray *tags;  // of Tag

@end

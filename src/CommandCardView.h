//
//  CommandCardView.h
//  Vim Cards
//
//  Created by Runhe Tian on 10/28/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"

@interface CommandCardView : GoogleNowCardView<UITextViewDelegate>

@property(nonatomic, strong) NSDictionary *notations;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

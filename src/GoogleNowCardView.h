//
//  GoogleNowCardView.h
//  Test
//
//  Created by Runhe Tian on 8/25/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoogleNowCardViewDelegate<NSObject>

- (void)favoriteButtonDidPressed:(id)sender;
- (void)shareButtonDidPressed:(NSString *)content;

@end

@interface GoogleNowCardView : UIView

#define PADDING_FROM_EDGE_OF_SCREEN_TO_CARD 8.0
#define SPACE_BETWEEN_CARDS 8.0

@property(strong, nonatomic) NSString *primaryText;
@property(strong, nonatomic) NSString *subtitleText;
@property(assign, nonatomic) BOOL isFavorite;
@property(assign, nonatomic) BOOL likeable;
@property(assign, nonatomic) BOOL shareable;
@property(strong, nonatomic) NSArray *tags;  // of NSString
@property(assign) id<GoogleNowCardViewDelegate> delegate;

@end

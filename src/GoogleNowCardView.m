//
//  GoogleNowCardView.m
//  Test
//
//  Created by Runhe Tian on 8/25/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"

@interface GoogleNowCardView ()

#define ROUNDED_CORNER_RADIUS 2.0  // dp

#define PRIMARY_TEXT_TOP_PADDING 24.0  // dp
#define SUBTITLE_TOP_PADDING 12.0      // dp
#define SUBTEXT_TOP_PADDING 16.0       // dp
#define SUBTEXT_BOTTOM_PADDING 16.0    // dp
#define TEXT_LEFT_RIGHT_PADDING 16.0   // dp
#define ACTIONS_PADDING 8.0            // dp
#define ACTIONS_SIZE 32.0              // dp

#define PRIMARY_TEXT_TEXT_SIZE 36.0  // sp
#define SUBTEXT_TEXT_SIZE 14.0       // sp

#define PRIMARY_TEXT_WIDTH 250.0
#define TAG_LIST_WIDTH 100.0
#define TAG_LENGTH 6.0

@property(strong, nonatomic) UILabel *primaryTextLabel;
@property(strong, nonatomic) UILabel *subtitleTextLabel;
@property(strong, nonatomic) UILabel *subTextLabel;
@property(strong, nonatomic) UIButton *likeButton;
@property(strong, nonatomic) UIButton *shareButton;

@end

@implementation GoogleNowCardView

- (id)initWithFrame:(CGRect)theFrame {
  self = [super initWithFrame:theFrame];
  if (self) {
    self.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    UIBezierPath *shadowPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   cornerRadius:ROUNDED_CORNER_RADIUS];
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowPath = shadowPath.CGPath;
    self.backgroundColor = [UIColor whiteColor];
  }
  [self layoutSubviews];
  return self;
}

- (void)setPrimaryText:(NSString *)primaryText {
  _primaryText = primaryText;
  self.primaryTextLabel.text = _primaryText;
  [self.primaryTextLabel
      setFont:[UIFont fontWithName:@"Roboto-Bold" size:PRIMARY_TEXT_TEXT_SIZE]];
}

- (UILabel *)primaryTextLabel {
  if (!_primaryTextLabel) {
    _primaryTextLabel = [[UILabel alloc] init];
  }
  return _primaryTextLabel;
}

- (void)setSubtitleText:(NSString *)subtitleText {
  _subtitleText = subtitleText;
  self.subtitleTextLabel.text = _subtitleText;
  [self.subtitleTextLabel
      setFont:[UIFont fontWithName:@"Roboto-Light" size:SUBTEXT_TEXT_SIZE]];
  [self.subtitleTextLabel sizeToFit];
}

- (UILabel *)subtitleTextLabel {
  if (!_subtitleTextLabel) {
    _subtitleTextLabel = [[UILabel alloc] init];
  }
  return _subtitleTextLabel;
}

- (void)setIsFavorite:(BOOL)isFavorite {
  _isFavorite = isFavorite;
  if (_isFavorite) {
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favorite"]
                               forState:UIControlStateNormal];
    [_likeButton setSelected:YES];
  } else {
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_border"]
                               forState:UIControlStateNormal];
    [_likeButton setSelected:NO];
  }
}

- (void)setLikeable:(BOOL)likeable {
  if (!likeable) {
    [_likeButton removeFromSuperview];
  }
}

- (void)setShareable:(BOOL)shareable {
  if (!shareable) {
    [_shareButton removeFromSuperview];
  }
}

- (UIButton *)likeButton {
  if (!_likeButton) {
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _likeButton;
}

- (UIButton *)shareButton {
  if (!_shareButton) {
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _shareButton;
}

- (void)setFrame:(CGRect)frame {
  frame.origin.x = PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  frame.origin.y = PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  frame.size.width -= PADDING_FROM_EDGE_OF_SCREEN_TO_CARD * 2;
  frame.size.height -= PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  [super setFrame:frame];

  [self addSubview:self.primaryTextLabel];
  [self addSubview:self.subtitleTextLabel];
  [self addSubview:self.likeButton];
  [self addSubview:self.shareButton];
}

- (void)layoutSubviews {
  [self layoutPrimaryTextLabel];
  [self layoutSubtitleTextLabel];
  [self layoutLikeButton];
  [self layoutShareButton];
}

- (void)layoutPrimaryTextLabel {
  CGFloat x = TEXT_LEFT_RIGHT_PADDING;
  CGFloat y = PRIMARY_TEXT_TOP_PADDING;
  CGFloat width = PRIMARY_TEXT_WIDTH;
  CGSize expectedLabelSize = [self.primaryText sizeWithAttributes:@{
    NSFontAttributeName :
        [UIFont fontWithName:@"Roboto-Bold" size:PRIMARY_TEXT_TEXT_SIZE]
  }];

  self.primaryTextLabel.frame =
      CGRectMake(x, y, width, expectedLabelSize.height);
}

- (void)layoutSubtitleTextLabel {
  CGFloat x = TEXT_LEFT_RIGHT_PADDING;
  CGFloat y = PRIMARY_TEXT_TOP_PADDING + _primaryTextLabel.frame.size.height +
              SUBTITLE_TOP_PADDING;
  CGFloat width = self.frame.size.width - 2 * TEXT_LEFT_RIGHT_PADDING - 50;

  self.subtitleTextLabel.frame = CGRectMake(x, y, width, 50);
  self.subtitleTextLabel.numberOfLines = 0;
  self.subtitleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)layoutLikeButton {
  CGFloat x = self.frame.size.width - ACTIONS_PADDING - ACTIONS_SIZE;
  CGFloat y = self.frame.size.height - ACTIONS_PADDING * 2 - ACTIONS_SIZE * 2 -
              PRIMARY_TEXT_TOP_PADDING;

  self.likeButton.frame = CGRectMake(x, y, ACTIONS_SIZE, ACTIONS_SIZE);
  [self.likeButton addTarget:self
                      action:@selector(favoriteButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)favoriteButtonPressed:(UIButton *)sender {
  if ([sender isSelected]) {
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_border"]
                               forState:UIControlStateNormal];
    [sender setSelected:NO];
  } else {
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favorite"]
                               forState:UIControlStateNormal];
    [sender setSelected:YES];
  }
  _isFavorite = !_isFavorite;
  [self.delegate favoriteButtonDidPressed:self];
}

- (void)layoutShareButton {
  CGFloat x = self.frame.size.width - ACTIONS_PADDING - ACTIONS_SIZE;
  CGFloat y = self.frame.size.height - PRIMARY_TEXT_TOP_PADDING - ACTIONS_SIZE;
  self.shareButton.frame = CGRectMake(x, y, ACTIONS_SIZE, ACTIONS_SIZE);
  [self.shareButton setBackgroundImage:[UIImage imageNamed:@"launch"]
                              forState:UIControlStateNormal];
  [self.shareButton addTarget:self.delegate
                       action:@selector(shareButtonDidPressed:)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareButtonDidPressed:(UIButton *)sender {
  NSString *content =
      [NSString stringWithFormat:@"%@\n%@", _primaryText, _subtitleText];
  [self.delegate shareButtonDidPressed:content];
}

@end

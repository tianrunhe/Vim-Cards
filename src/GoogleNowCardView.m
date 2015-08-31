//
//  GoogleNowCardView.m
//  Test
//
//  Created by Runhe Tian on 8/25/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "GoogleNowCardView.h"

@interface GoogleNowCardView ()

#define ROUNDED_CORNER_RADIUS 2.0 // dp

#define PRIMARY_TEXT_TOP_PADDING 24.0 // dp
#define SUBTITLE_TOP_PADDING 12.0     // dp
#define SUBTEXT_TOP_PADDING 16.0      // dp
#define SUBTEXT_BOTTOM_PADDING 16.0   // dp
#define TEXT_LEFT_RIGHT_PADDING 16.0  // dp
#define ACTIONS_PADDING 8.0           // dp
#define ACTIONS_SIZE 32.0             // dp

#define PRIMARY_TEXT_TEXT_SIZE 24.0 // sp
#define SUBTEXT_TEXT_SIZE 14.0      // sp

@property(strong, nonatomic) UILabel *primaryTextLabel;
@property(strong, nonatomic) UILabel *subtitleTextLabel;
@property(strong, nonatomic) UILabel *subTextLabel;
@property(strong, nonatomic) UIButton *action1Button;
@property(strong, nonatomic) UIButton *action2Button;

@end

@implementation GoogleNowCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPrimaryText:(NSString *)primaryText {
  _primaryText = primaryText;
  self.primaryTextLabel.text = _primaryText;
  [self.primaryTextLabel setFont:[UIFont fontWithName:@"Roboto-Light"
                                                 size:PRIMARY_TEXT_TEXT_SIZE]];
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
}

- (UILabel *)subtitleTextLabel {
  if (!_subtitleTextLabel) {
    _subtitleTextLabel = [[UILabel alloc] init];
  }
  return _subtitleTextLabel;
}

- (void)setAction1Text:(NSString *)action1Text {
  _action1Text = action1Text;
  [self.action1Button.titleLabel
      setFont:[UIFont fontWithName:@"Roboto-Light"
                              size:PRIMARY_TEXT_TEXT_SIZE]];
}

- (UIButton *)action1Button {
  if (!_action1Button) {
    _action1Button = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _action1Button;
}

- (void)setAction2Text:(NSString *)action1Text {
  _action2Text = action1Text;
  [self.action2Button.titleLabel
      setFont:[UIFont fontWithName:@"Roboto-Light"
                              size:PRIMARY_TEXT_TEXT_SIZE]];
}

- (UIButton *)action2Button {
  if (!_action2Button) {
    _action2Button = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _action2Button;
}

- (void)setFrame:(CGRect)frame {
  frame.origin.x = PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  frame.origin.y = PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  frame.size.width -= PADDING_FROM_EDGE_OF_SCREEN_TO_CARD * 2;
  frame.size.height -= PADDING_FROM_EDGE_OF_SCREEN_TO_CARD;
  [super setFrame:frame];

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

  [self addSubview:self.primaryTextLabel];
  [self addSubview:self.subtitleTextLabel];
  [self addSubview:self.action1Button];
  [self addSubview:self.action2Button];
}

- (void)layoutSubviews {
  [self layoutPrimaryTextLabel];
  [self layoutSubtitleTextLabel];
  [self layoutActionButton1];
  [self layoutActionButton2];
}

- (void)layoutPrimaryTextLabel {
  CGFloat x = TEXT_LEFT_RIGHT_PADDING;
  CGFloat y = PRIMARY_TEXT_TOP_PADDING;
  CGFloat width = self.frame.size.width - 2 * TEXT_LEFT_RIGHT_PADDING;
  CGSize expectedLabelSize = [self.primaryText sizeWithAttributes:@{
    NSFontAttributeName :
        [UIFont fontWithName:@"Roboto-Light" size:PRIMARY_TEXT_TEXT_SIZE]
  }];

  self.primaryTextLabel.frame =
      CGRectMake(x, y, width, expectedLabelSize.height);
}

- (void)layoutSubtitleTextLabel {
  CGFloat x = TEXT_LEFT_RIGHT_PADDING;
  CGFloat y = PRIMARY_TEXT_TOP_PADDING + _primaryTextLabel.frame.size.height +
              SUBTITLE_TOP_PADDING;
  CGFloat width = self.frame.size.width - 2 * TEXT_LEFT_RIGHT_PADDING;

  self.subtitleTextLabel.frame = CGRectMake(x, y, width, 32);
}

- (void)layoutActionButton1 {
  CGFloat x = self.frame.size.width - ACTIONS_SIZE - TEXT_LEFT_RIGHT_PADDING;
  // CGFloat y = PRIMARY_TEXT_TOP_PADDING + _primaryTextLabel.frame.size.height
  // + SUBTITLE_TOP_PADDING + _subtitleTextLabel.frame.size.height +
  // SUBTEXT_BOTTOM_PADDING + ACTIONS_PADDING;
  CGFloat y = PRIMARY_TEXT_TOP_PADDING;

  self.action1Button.frame = CGRectMake(x, y, ACTIONS_SIZE, ACTIONS_SIZE);
  [self.action1Button setBackgroundImage:[UIImage imageNamed:@"favorite"]
                                forState:UIControlStateNormal];
  [self.action1Button
      setBackgroundImage:[UIImage imageNamed:@"favorite-clicked"]
                forState:UIControlStateSelected | UIControlStateHighlighted];
  [self.action1Button addTarget:self
                         action:@selector(favoriteButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)favoriteButtonPressed:(UIButton *)sender {
  if ([sender isSelected]) {
    [self.action1Button setBackgroundImage:[UIImage imageNamed:@"favorite"]
                                  forState:UIControlStateNormal];
    [sender setSelected:NO];
  } else {
    [self.action1Button
        setBackgroundImage:[UIImage imageNamed:@"favorite-clicked"]
                  forState:UIControlStateNormal];
    [sender setSelected:YES];
  }
  NSLog(@"favorite button clicked!");
}

- (void)layoutActionButton2 {
  CGFloat x = self.frame.size.width - ACTIONS_SIZE - TEXT_LEFT_RIGHT_PADDING;
  // CGFloat y = PRIMARY_TEXT_TOP_PADDING + _primaryTextLabel.frame.size.height
  // + SUBTITLE_TOP_PADDING + _subtitleTextLabel.frame.size.height +
  // SUBTEXT_BOTTOM_PADDING + ACTIONS_PADDING;
  CGFloat y = self.frame.size.height - PRIMARY_TEXT_TOP_PADDING - ACTIONS_SIZE;

  self.action2Button.frame = CGRectMake(x, y, ACTIONS_SIZE, ACTIONS_SIZE);
  [self.action2Button setBackgroundImage:[UIImage imageNamed:@"action"]
                                forState:UIControlStateNormal];
  [self.action2Button addTarget:self.delegate
                         action:@selector(shareButtonDidPressed)
               forControlEvents:UIControlEventTouchUpInside];
}

@end

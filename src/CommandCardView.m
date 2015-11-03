//
//  CommandCardView.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/28/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandCardView.h"
#import "Notation.h"

#define SUBTEXT_TEXT_SIZE 14.0

@implementation CommandCardView

- (void)setSubtitleText:(NSString *)subtitleText {
  [super setSubtitleText:subtitleText];
  NSMutableAttributedString *mutableString =
      [[NSMutableAttributedString alloc] initWithString:subtitleText];

  BOOL match = NO;
  for (id object in self.notations) {
    NSString *title = (NSString *)object;
    NSUInteger length = self.subtitleText.length;
    NSRange range = NSMakeRange(0, length);
    while (range.location != NSNotFound) {
      range = [self.subtitleText rangeOfString:title options:0 range:range];
      if (range.location != NSNotFound) {
        //        [mutableString addAttribute:NSForegroundColorAttributeName
        //                              value:[UIColor blueColor]
        //                              range:range];
        NSString *urlString =
            [[NSString stringWithFormat:@"vimcards://notation/?title=%@", title]
                stringByAddingPercentEncodingWithAllowedCharacters:
                    [NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlString];

        [mutableString addAttribute:NSLinkAttributeName value:url range:range];
        [mutableString addAttribute:@"title" value:title range:range];
        match = YES;
        range = NSMakeRange(range.location + range.length,
                            length - (range.location + range.length));
      }
    }
  }
  //  if (match) {
  //    _tapGesture =
  //        [[UITapGestureRecognizer alloc] initWithTarget:self
  //                                                action:@selector(textTapped:)];
  //    [self addGestureRecognizer:_tapGesture];
  //  }

  self.subtitleTextView.attributedText = mutableString;
}

- (BOOL)textView:(UITextView *)textView
    shouldInteractWithURL:(NSURL *)url
                  inRange:(NSRange)characterRange {
  return YES;
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer {
  UITextView *textView = (UITextView *)recognizer.view;

  NSLayoutManager *layoutManager = textView.layoutManager;
  CGPoint location = [recognizer locationInView:textView];
  location.x -= textView.textContainerInset.left;
  location.y -= textView.textContainerInset.top;

  NSUInteger characterIndex;
  characterIndex = [layoutManager characterIndexForPoint:location
                                         inTextContainer:textView.textContainer
                fractionOfDistanceBetweenInsertionPoints:NULL];

  if (characterIndex < textView.textStorage.length) {
    NSRange range;
    id value = [textView.attributedText attribute:@"title"
                                          atIndex:characterIndex
                                   effectiveRange:&range];

    NSString *titile = (NSString *)value;

    NSLog(@"%@, %lu, %lu", titile, (unsigned long)range.location,
          (unsigned long)range.length);
  }
}

@end

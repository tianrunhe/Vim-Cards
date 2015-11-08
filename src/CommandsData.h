//
//  CommandsData.h
//  Vim Cards
//
//  Created by Runhe Tian on 11/8/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandsData : NSObject {
  NSArray *commands;  // of Command
}

@property(nonatomic, retain) NSArray *commands;

+ (CommandsData *)instance;

@end

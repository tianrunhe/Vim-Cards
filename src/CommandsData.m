//
//  CommandsData.m
//  Vim Cards
//
//  Created by Runhe Tian on 11/8/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "CommandsData.h"

@implementation CommandsData
@synthesize commands;

static CommandsData *instance = nil;

+ (CommandsData *)instance {
  @synchronized(self) {
    if (instance == nil) {
      instance = [CommandsData new];
    }
  }
  return instance;
}

@end

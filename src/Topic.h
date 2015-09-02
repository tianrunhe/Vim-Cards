//
//  Topic.h
//  Vim Cards
//
//  Created by Runhe Tian on 9/1/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Command;

@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *commands;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addCommandsObject:(Command *)value;
- (void)removeCommandsObject:(Command *)value;
- (void)addCommands:(NSSet *)values;
- (void)removeCommands:(NSSet *)values;

@end

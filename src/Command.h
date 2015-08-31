//
//  Command.h
//  Vim.gif
//
//  Created by Runhe Tian on 8/19/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AWSDynamoDB/AWSDynamoDB.h>

@class CommandCategory, CommandTag;

@interface Command : NSManagedObject

@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSData *data;
@property(nonatomic, retain) NSNumber *favorite;
@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, retain) NSNumber *purchase;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSSet *tags;
@property(nonatomic, retain) CommandCategory *category;
@end

@interface Command (CoreDataGeneratedAccessors)

- (void)addTagsObject:(CommandTag *)value;
- (void)removeTagsObject:(CommandTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

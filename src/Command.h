//
//  Command.h
//  Vim Cards
//
//  Created by Runhe Tian on 8/31/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag, Topic;

@interface Command : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * purchase;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * usage;
@property (nonatomic, retain) NSNumber * vi;
@property (nonatomic, retain) Topic *topic;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Command (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

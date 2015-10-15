//
//  Command+DynamoDB.m
//  Vim.gif
//
//  Created by Runhe Tian on 8/19/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "Command+DynamoDB.h"
#import "Tag.h"

@implementation Command (DynamoDB)

+ (Command *)commandWithDynamoDBRow:(NSDictionary *)dynamoDBRow
             inManagedObjectContext:(NSManagedObjectContext *)context {
  Command *command = nil;

  NSString *title = [[dynamoDBRow objectForKey:@"title"] valueForKey:@"S"];
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];

  NSError *error;
  NSArray *matches = [context executeFetchRequest:request error:&error];

  if (!matches || error || ([matches count] > 1)) {
    return nil;
  } else if ([matches count]) {
    command = [matches firstObject];
  } else {
    command = [NSEntityDescription insertNewObjectForEntityForName:@"Command"
                                            inManagedObjectContext:context];
  }
  command.title = [[dynamoDBRow objectForKey:@"title"] valueForKey:@"S"];
  command.content = [[dynamoDBRow objectForKey:@"content"] valueForKey:@"S"];
  command.usage = [[dynamoDBRow objectForKey:@"usage"] valueForKey:@"S"];

  [command removeTags:command.tags];
  for (AWSDynamoDBAttributeValue *tagAttribute in
       [[dynamoDBRow objectForKey:@"tags"] valueForKey:@"L"]) {
    NSString *tagName = [tagAttribute valueForKey:@"S"];
    Tag *tag = nil;
    NSFetchRequest *request =
        [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];

    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || error || ([matches count] > 1)) {
      // do nothing
    } else if ([matches count]) {
      tag = [matches firstObject];
    } else {
      tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                          inManagedObjectContext:context];
    }
    tag.name = tagName;
    [command addTagsObject:tag];
  }

  return command;
}

+ (void)loadCommandsFromDynamoDBScanOutput:
            (AWSDynamoDBScanOutput *)dynamoDBScanOutput
                  intoManagedObjectContext:(NSManagedObjectContext *)context {
  for (NSDictionary *dynamoDBRow in dynamoDBScanOutput.items) {
    [self commandWithDynamoDBRow:dynamoDBRow inManagedObjectContext:context];
  }
}

@end

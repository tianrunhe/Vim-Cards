//
//  Notation+DynamoDB.m
//  Vim Cards
//
//  Created by Runhe Tian on 10/28/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "Notation+DynamoDB.h"

@implementation Notation (DynamoDB)

+ (Notation *)notationWithDynamoDBRow:(NSDictionary *)dynamoDBRow
               inManagedObjectContext:(NSManagedObjectContext *)context {
  Notation *notation = nil;

  NSString *title = [[dynamoDBRow objectForKey:@"title"] valueForKey:@"S"];
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Notation"];
  request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];

  NSError *error;
  NSArray *matches = [context executeFetchRequest:request error:&error];

  if (!matches || error || ([matches count] > 1)) {
    return nil;
  } else if ([matches count]) {
    notation = [matches firstObject];
  } else {
    notation = [NSEntityDescription insertNewObjectForEntityForName:@"Notation"
                                             inManagedObjectContext:context];
  }
  notation.title = [[dynamoDBRow objectForKey:@"title"] valueForKey:@"S"];
  notation.content = [[dynamoDBRow objectForKey:@"content"] valueForKey:@"S"];

  return notation;
}

+ (void)loadNotationsFromDynamoDBScanOutput:
            (AWSDynamoDBScanOutput *)dynamoDBScanOutput
                   intoManagedObjectContext:(NSManagedObjectContext *)context {
  for (NSDictionary *dynamoDBRow in dynamoDBScanOutput.items) {
    [self notationWithDynamoDBRow:dynamoDBRow inManagedObjectContext:context];
  }
}

@end

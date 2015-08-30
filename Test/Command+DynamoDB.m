//
//  Command+DynamoDB.m
//  Vim.gif
//
//  Created by Runhe Tian on 8/19/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "Command+DynamoDB.h"

@implementation Command (DynamoDB)

+ (Command *)commandWithDynamoDBRow:(NSDictionary *)dynamoDBRow
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    Command *command = nil;
    
    NSNumber *id = [dynamoDBRow objectForKey:@"id"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Command"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        command = [matches firstObject];
    } else {
        command = [NSEntityDescription insertNewObjectForEntityForName:@"Command"
                                              inManagedObjectContext:context];
        // Initialize commands here
        
    }
    
    return command;
}

+ (void)loadCommandsFromDynamoDBScanOutput:(AWSDynamoDBScanOutput *)dynamoDBScanOutput
                  intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *dynamoDBRow in dynamoDBScanOutput.items) {
        [self commandWithDynamoDBRow:dynamoDBRow inManagedObjectContext:context];
    }
}


@end

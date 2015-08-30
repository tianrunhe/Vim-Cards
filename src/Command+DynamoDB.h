//
//  Command+DynamoDB.h
//  Vim.gif
//
//  Created by Runhe Tian on 8/19/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "Command.h"
#import <AWSDynamoDB/AWSDynamoDB.h>

@interface Command (DynamoDB)

+ (Command *)commandWithDynamoDBRow:(NSDictionary *)dynamoDBRow
             inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadCommandsFromDynamoDBScanOutput:(AWSDynamoDBScanOutput *)dynamoDBScanOutput
                  intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

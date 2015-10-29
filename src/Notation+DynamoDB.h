//
//  Notation+DynamoDB.h
//  Vim Cards
//
//  Created by Runhe Tian on 10/28/15.
//  Copyright © 2015 Runhe Tian. All rights reserved.
//

#import "Notation.h"
#import <AWSDynamoDB/AWSDynamoDB.h>

@interface Notation (DynamoDB)

+ (Notation *)notationWithDynamoDBRow:(NSDictionary *)dynamoDBRow
               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadNotationsFromDynamoDBScanOutput:
            (AWSDynamoDBScanOutput *)dynamoDBScanOutput
                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

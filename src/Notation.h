//
//  Notation.h
//  Vim Cards
//
//  Created by Runhe Tian on 9/1/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notation : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;

@end

//
//  AppDelegate.h
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVParser.h"

@interface AppDelegate : UIResponder<UIApplicationDelegate, CHCSVParserDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong, nonatomic)
    NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic)
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly) NSArray *lines;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

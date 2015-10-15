//
//  AppDelegate.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "AppDelegate.h"
#import "CommandSearchViewController.h"
#import "Command+DynamoDB.h"
#import "Tag.h"
#import <AWSCore/AWSCore.h>
#import <AWSDynamoDB/AWSDynamoDB.h>

@interface AppDelegate () {
  NSMutableArray *_lines;
  NSMutableArray *_currentLine;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];

  [self configureAWSResources];
  [self startDynamoDBSync];
  [self createRootViewController];

#ifdef DEBUG
  NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentPath = [searchPaths objectAtIndex:0];
  NSLog(@"document path is: %@", documentPath);
#endif

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
  [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
  [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
  [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This
  // code uses a directory named "com.amazon.tianrunhe.Temp" in the
  // application's documents directory.
  return [[[NSFileManager defaultManager]
      URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the
  // application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL =
      [[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"mom"];
  _managedObjectModel =
      [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation
  // creates and return a coordinator, having added the store for the
  // application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }

  // Create the coordinator and store

  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
      initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory]
      URLByAppendingPathComponent:@"coreData.sqlite"];
  NSLog(@"Core Data store path = \"%@\"", [storeURL path]);
  NSError *error = nil;
  NSString *failureReason =
      @"There was an error creating or loading the application's saved data.";
  NSDictionary *options = @{
    NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}
  };
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:options
                                                         error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] =
        @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error =
        [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You
    // should not use this function in a shipping application, although it may
    // be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already
  // bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc]
      initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] &&
        ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error
      // appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although it
      // may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

#pragma mark - configurations
- (void)configureAWSResources {
  [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
  AWSCognitoCredentialsProvider *credentialsProvider =
      [[AWSCognitoCredentialsProvider alloc]
          initWithRegionType:AWSRegionUSEast1
              identityPoolId:@"us-east-1:2a03f595-893e-4705-8f21-fa40a2882576"];
  AWSServiceConfiguration *configuration =
      [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                  credentialsProvider:credentialsProvider];
  AWSServiceManager.defaultServiceManager.defaultServiceConfiguration =
      configuration;
}

- (void)createRootViewController {
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate = nil;
  request.sortDescriptors = @[
    [NSSortDescriptor
        sortDescriptorWithKey:@"title"
                    ascending:YES
                     selector:@selector(localizedStandardCompare:)]
  ];

  NSFetchedResultsController *fetchedResultsController =
      [[NSFetchedResultsController alloc]
          initWithFetchRequest:request
          managedObjectContext:self.managedObjectContext
            sectionNameKeyPath:nil
                     cacheName:nil];
  CommandSearchViewController *rootViewController =
      [[CommandSearchViewController alloc]
          initWithFetchedResultsController:fetchedResultsController];
  rootViewController.commandsCDTVC.debug = YES;
  rootViewController.commandsCDTVC.fetchedResultsController =
      fetchedResultsController;

  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
}

#pragma mark - background fetch
- (void)startDynamoDBSync {
  AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
  AWSDynamoDBScanInput *scanInput = [AWSDynamoDBScanInput new];
  scanInput.tableName = @"Vim-commands";
  [[[dynamoDB scan:scanInput] continueWithBlock:^id(AWSTask *task) {
    [Command loadCommandsFromDynamoDBScanOutput:task.result
                       intoManagedObjectContext:self.managedObjectContext];
    return nil;
  }] waitUntilFinished];
}

@end

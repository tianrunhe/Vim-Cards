//
//  AppDelegate.m
//  Test
//
//  Created by Runhe Tian on 8/24/15.
//  Copyright (c) 2015 Runhe Tian. All rights reserved.
//

#import "AppDelegate.h"
#import "CommandsCDTVC.h"
#import "Command.h"
#import "Tag.h"
#import "CHCSVParser.h"

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
  CommandsCDTVC *rootViewController = [[CommandsCDTVC alloc] init];
  rootViewController.debug = YES;

  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate = nil;
  request.sortDescriptors = @[
    [NSSortDescriptor
        sortDescriptorWithKey:@"title"
                    ascending:YES
                     selector:@selector(localizedStandardCompare:)]
  ];
  NSArray *results =
      [self.managedObjectContext executeFetchRequest:request error:Nil];
  if (![results count]) {  // empty results
    CHCSVParser *csvParser = [[CHCSVParser alloc]
        initWithContentsOfCSVURL:[[NSBundle mainBundle]
                                     URLForResource:@"Learn Vim Progressively"
                                      withExtension:@"csv"]];
    csvParser.recognizesBackslashesAsEscapes = YES;
    csvParser.sanitizesFields = YES;
    csvParser.delegate = self;
    [csvParser parse];
  }

  NSFetchedResultsController *fetchedResultsController =
      [[NSFetchedResultsController alloc]
          initWithFetchRequest:request
          managedObjectContext:self.managedObjectContext
            sectionNameKeyPath:nil
                     cacheName:nil];
  rootViewController.fetchedResultsController = fetchedResultsController;

  UINavigationController *nav = [[UINavigationController alloc]
      initWithRootViewController:rootViewController];
  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];

  NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentPath = [searchPaths objectAtIndex:0];
  NSLog(@"document path is: %@", documentPath);
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

#pragma mark - CHCSVParserDelegate

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
  _currentLine = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser
  didReadField:(NSString *)field
       atIndex:(NSInteger)fieldIndex {
  [_currentLine addObject:field];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
  [_lines addObject:_currentLine];

  Command *command = nil;
  Tag *tag = nil;
  NSString *title = _currentLine[0];
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"Command"];
  request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];

  NSError *error;
  NSArray *matches =
      [self.managedObjectContext executeFetchRequest:request error:&error];

  if (!matches || error || ([matches count] > 1)) {
    // handle error
  } else if ([matches count]) {
    command = [matches firstObject];
  } else {
    command = [NSEntityDescription
        insertNewObjectForEntityForName:@"Command"
                 inManagedObjectContext:self.managedObjectContext];
    command.title = title;
    command.usage = _currentLine[1];
    command.content = _currentLine[2];

    tag = [NSEntityDescription
        insertNewObjectForEntityForName:@"Tag"
                 inManagedObjectContext:self.managedObjectContext];
    tag.name = _currentLine[3];
    [command addTagsObject:tag];
    _currentLine = nil;
  }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
  NSLog(@"ERROR: %@", error);
  _lines = nil;
}

@end

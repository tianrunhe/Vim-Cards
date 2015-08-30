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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    CommandsCDTVC *rootViewController = [[CommandsCDTVC alloc] init];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                  inDomains:NSUserDomainMask] firstObject];
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:@"coreData"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    NSManagedObjectContext *managedObject = document.managedObjectContext;

    Command *command = [NSEntityDescription insertNewObjectForEntityForName:@"Command"
                                  inManagedObjectContext:managedObject];
    command.title = @"Ctrl-F";
    command.content = @"Move one word forward";
    //[document saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Command"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];

    
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:request
                                                                        managedObjectContext:managedObject
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    rootViewController.fetchedResultsController = fetchedResultsController;

    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:rootViewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSLog(@"document path is: %@", documentPath);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

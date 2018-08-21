//
//  AppDelegate.m
//  tableViewCoreData
//
//  Created by Mircea Popescu on 8/9/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // If this next line is not added, the coredata will not be initialized and the context, in this case, myContext, will be nil, giving an error when trying to run this in ViewCOntroller -> [self initialiseNSFetchedResultsControllerDelegate]; The problem will come actually from this line of code -> fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:_myContext]; as myContext is nil, hence the error we are getting -> "nil is not a legal NSManagedObjectContext parameter searching for entity name 'ToDoEntity''"
    [self persistentContainer];
    
    ViewController *rootVC = (ViewController *)_window.rootViewController;
    rootVC.myContext = _persistentContainer.viewContext;

    
    return YES;
}

// I get this error -> Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '+entityForName: nil is not a legal NSManagedObjectContext parameter searching for entity name 'ToDoEntity''


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"tableViewCoreData"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

//
//  AppDelegate.m
//  HelloCBL
//
//  Created by Anar Enhsaihan on 4/27/15.
//  Copyright (c) 2015 Couchbase. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

// the manager and database would not generally be stored as private objects

// shared manager
@property (strong, nonatomic) CBLManager *manager;
// the database
@property (strong, nonatomic) CBLDatabase *database;
// document identifier
// used to demonstrate CRUD operations
// each time you run the app, the document
// it creates will have a different identifier
@property (strong, nonatomic) NSString *docID;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // create a view controller so the app doesn't complain about not having one
    // (we are not doing a UI here, so we don't really need one)
    self.window.rootViewController = [[UIViewController alloc] init];
    // create a shared instance of CBLManager
    if (![self createTheManager]) return NO;
    // Run the method that controls the app
    BOOL result = [self sayHello];
    NSLog (@"This Hello Couchbase Lite run was a %@!",
           (result ? @"total success" : @"dismal failure"));
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

#pragma mark Main Method
/*
 The sayHello method controls the tutorial app. It first creates a
 manager and a database to store documents in. Next it creates and
 stores a new document. Then it uses the document that was created
 to demonstrate the remaining CRUD operations by retrieving the
 document, updating the document, and deleting the document.
 */
- (BOOL) sayHello {
    
    // create a database
    if (![self createTheDatabase]) return NO;
    
    // create a new document and save it in the database
    if (![self createTheDocument]) return NO;
    // retrieve a document from the database
    if (![self retrieveTheDocument]) return NO;
    
    // update a document
    if (![self updateTheDocument]) return NO;
    
    // delete a document
    if (![self deleteTheDocument]) return NO;
    return YES;
}
#pragma mark Manager and Database Methods
// creates the manager object
- (BOOL) createTheManager {
    
    // create a shared instance of CBLManager
    _manager = [CBLManager sharedInstance];
    if (!_manager) {
        NSLog(@"Cannot create shared instance of CBLManager");
        return NO;
    }
    
    NSLog(@"Manager created");
    
    return YES;
}

// creates the database
- (BOOL) createTheDatabase {
    
    NSError *error;
    
    // create a name for the database and make sure the name is legal
    NSString *dbname = @"my-new-database";
    if (![CBLManager isValidDatabaseName:dbname]) {
        NSLog(@"Bad database name");
        return NO;
    }
    
    // create a new database
    _database = [_manager databaseNamed:dbname error:&error];
    if (!_database) {
        NSLog(@"Cannot create database. Error message: %@", error.localizedDescription);
        return NO;
    }
    
    // log the database location
    NSString *databaseLocation =
    [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]
     stringByAppendingString: @"/Library/Application Support/CouchbaseLite"];
    NSLog(@"Database %@ created at %@", dbname,
          [NSString stringWithFormat:@"%@/%@%@", databaseLocation, dbname, @".cblite"]);
    
    return YES;
}
#pragma mark CRUD Methods
// creates the document
- (BOOL) createTheDocument {
    
    NSError *error;
    
    // create an object that contains data for the new document
    NSDictionary *myDictionary = @{@"message" : @"Hello Couchbase Lite!",
                                   @"name" : @"Joey",
                                   @"age" : @15,
                                   @"timestamp" : [[NSDate date] description]};
    
    // display the data for the new document
    NSLog(@"This is the data for the document: %@", myDictionary);
    
    // create an empty document
    CBLDocument *doc = [_database createDocument];
    
    // save the ID of the new document
    _docID = doc.documentID;
    
    // write the document to the database
    CBLRevision *newRevision =  [doc putProperties:myDictionary error:&error];
    if (!newRevision) {
        NSLog(@"Cannot write document to database. Error message: %@", error.localizedDescription);
        return NO;
    }
    
    NSLog(@"Document created and written to database. ID = %@", _docID);
    return YES;
}
// retrieves the document
- (BOOL) retrieveTheDocument {
    
    // retrieve the document from the database
    CBLDocument *retrievedDoc = [_database documentWithID:_docID];
    
    // display the retrieved document
    NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    return YES;
}
// updates the document
- (BOOL) updateTheDocument {return YES;}
// deletes the document
- (BOOL) deleteTheDocument {return YES;}

@end

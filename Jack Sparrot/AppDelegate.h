//
//  AppDelegate.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewControllerAcceuil.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

- (void)saveContext;


@end


//
//  AppDelegate.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionBuilder.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	CollectionBuilder *builder = [[CollectionBuilder alloc] init];
	UIViewController *viewController = [builder buildModule];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	self.window.rootViewController = navigationController;

	[self.window makeKeyAndVisible];

	return YES;
}

@end

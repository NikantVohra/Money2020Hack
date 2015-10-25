//
//  AppDelegate.m
//  EstimoteExample
//
//  Created by Vohra, Nikant on 23/10/15.
//  Copyright © 2015 Vohra, Nikant. All rights reserved.
//

#import "AppDelegate.h"
#import <PULPulsate/PULPulsate.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    PULPulsateManager* _pulsateManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSError* error;
    
    PULAuthorizationData* authData = [[PULAuthorizationData alloc] initWithAppId:@"2dc7ebe084282ea6e09f02a60510b20393ec4f618d5c27584b3d48603af44340" andAppKey:@"8005943fed35b0531fffc28a65eba29c23ffddd1c487d85a8490ca255eb1c6a3" validationError:&error];
        
    _pulsateManager = [PULPulsateFactory getInstanceWithAuthorizationData:authData withLocationEnabled:YES withPushEnabled:YES withLaunchOptions:launchOptions error:&error];
    [_pulsateManager startPulsateSession];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
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

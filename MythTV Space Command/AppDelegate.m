//
//  AppDelegate.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/7/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "AppDelegate.h"
#import "RBVolumeButtons.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

RBVolumeButtons *buttonStealer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    
    self.conn = [[SocketConnection alloc] init];
    
    buttonStealer = [[RBVolumeButtons alloc] init];
    
    buttonStealer.upBlock = ^{
        [self.conn sendMessage:@"KEY ]\n"];
    };
    buttonStealer.downBlock = ^{
        [self.conn sendMessage:@"KEY [\n"];
    };

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [buttonStealer stopStealingVolumeButtonEvents];
    
    [self.conn disconnectFromRemoteControlInterface];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *frontendIP = [defaults stringForKey:@"frontend_ip_preference"];
    if (frontendIP == nil || frontendIP.length == 0) {
        frontendIP = @"192.168.0.2";
        [defaults setObject:frontendIP forKey:@"frontend_ip_preference"];
    }
    NSString *frontendPort = [defaults stringForKey:@"frontend_port_preference"];
    if (frontendPort == nil) {
        frontendPort = @"6543";
        [defaults setObject:frontendPort forKey:@"frontend_port_preference"];
    }
    NSString *muteLevelPerc =[defaults stringForKey:@"mute_level_preference"];
    if (muteLevelPerc == nil) {
        muteLevelPerc = @"15";
        [defaults setObject:muteLevelPerc forKey:@"mute_level_preference"];
    }
    [defaults synchronize];
    
    self.conn.frontendIP = frontendIP;
    self.conn.frontendPort = frontendPort;

    [self.conn connectToRemoteControlInterface];
    
    [buttonStealer startStealingVolumeButtonEvents];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  AppDelegate.h
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/7/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketConnection.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SocketConnection *conn;

@end


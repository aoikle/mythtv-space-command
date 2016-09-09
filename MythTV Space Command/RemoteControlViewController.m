//
//  RemoteControlViewController.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/11/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "RemoteControlViewController.h"
#import "AppDelegate.h"
#import "SocketConnection.h"


@interface RemoteControlViewController ()
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;
@property (weak, nonatomic) IBOutlet UIButton *volDownButton;
@property (weak, nonatomic) IBOutlet UIButton *volUpButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *fillButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RemoteControlViewController

SocketConnection *conn;
NSMutableString *currentVolume;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNeedsStatusBarAppearanceUpdate];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    conn = appDelegate.conn;
    
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonClick:(id)sender {
    /*
    MSCSendMessageCompleteBlock callback = ^(BOOL wasSuccessful,
                                             NSString *lastMessageSent,
                                             NSString *response) {
        if (wasSuccessful) {
            if ([lastMessageSent isEqual:@"query volume\n"]) {
                [currentVolume setString:[response componentsSeparatedByString:@"\r\n#"][0]];
                NSString *message;
                if (currentVolume == nil) {
                    message = @"play volume 0%\n";
                }
                [conn sendMessage:message];
            }
        } else {
            
        }
    };
    */
    if (sender == self.muteButton) {
        [conn sendMessage:@"KEY |\n"];
        //[conn sendMessage:@"query volume\n" withCallback:callback];
    }
    if (sender == self.volDownButton) {
        [conn sendMessage:@"KEY [\n"];
    }
    if (sender == self.volUpButton) {
        [conn sendMessage:@"KEY ]\n"];
    }
    if (sender == self.guideButton) {
        [conn sendMessage:@"KEY s\n"];
    }
    if (sender == self.menuButton) {
        [conn sendMessage:@"KEY m\n"];
    }
    if (sender == self.pauseButton) {
        [conn sendMessage:@"KEY p\n"];
    }
    if (sender == self.exitButton) {
        [conn sendMessage:@"KEY escape\n"];
    }
    if (sender == self.upButton) {
        [conn sendMessage:@"KEY up\n"];
    }
    if (sender == self.downButton) {
        [conn sendMessage:@"KEY down\n"];
    }
    if (sender == self.leftButton) {
        [conn sendMessage:@"KEY left\n"];
    }
    if (sender == self.rightButton) {
        [conn sendMessage:@"KEY right\n"];
    }
    if (sender == self.okButton) {
        [conn sendMessage:@"KEY enter\n"];
    }
    if (sender == self.fillButton) {
        [conn sendMessage:@"KEY w\n"];
    }
    if (sender == self.infoButton) {
        [conn sendMessage:@"KEY i\n"];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

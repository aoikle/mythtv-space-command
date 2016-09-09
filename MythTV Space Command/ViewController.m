//
//  ViewController.m
//  MythTV Space Command
//
//  Created by Andrew Oikle on 12/7/14.
//  Copyright (c) 2014 Andrew Oikle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initNetworkCommunication];
    
    [self sendString:@"play channel up\n"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

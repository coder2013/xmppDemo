//
//  LoginViewController.m
//  XMPP1112
//
//  Created by shuqiong on 11/13/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPServer.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登陆";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_login:(id)sender {
    
    [[XMPPServer sharedInstance] setupUserInfoName:@"coder01" Password:@"000000" Domain:@"shuqiong" Server:@"192.168.0.153" Port:5222];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isBlankText:(NSString *)value {
    
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    return value.length > 0 ? NO : YES;
}

@end

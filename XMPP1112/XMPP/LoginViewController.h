//
//  LoginViewController.h
//  XMPP1112
//
//  Created by shuqiong on 11/13/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

- (IBAction)action_login:(id)sender;

@end

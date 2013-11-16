//
//  ChatViewController.h
//  XMPP1112
//
//  Created by shuqiong on 11/16/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQXMPPRoom.h"

@interface ChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) SQXMPPRoom *roomItem;

- (IBAction)action_send:(id)sender;

@end

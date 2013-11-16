//
//  ChatViewController.m
//  XMPP1112
//
//  Created by shuqiong on 11/16/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import "ChatViewController.h"
#import "XMPPServer.h"

@interface ChatViewController () <UITableViewDelegate,UITableViewDataSource,MessageDelegate> {
    
    NSMutableArray *messagesArray;
}

@end

@implementation ChatViewController

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
    messagesArray = [NSMutableArray array];
    [XMPPServer sharedInstance].messageDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    /*   //退出
     <presence
     from='hag66@shakespeare.lit/pda'
     to='darkcave@chat.shakespeare.lit/thirdwitch'
     type='unavailable'/>
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XMPPMessage *messageItem = messagesArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",messageItem.from.resource,messageItem.body];
    
    return cell;
}

- (IBAction)action_send:(id)sender {
    
   /*
    例子 60. 房客发送一个消息给所有房客
    <message
    from='hag66@shakespeare.lit/pda'
    to='darkcave@chat.shakespeare.lit'
    type='groupchat'>
    <body>Harpier cries: 'tis time, 'tis time.</body>
    </message>
    */
    XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat"];
    [message addAttributeWithName:@"from" stringValue:@"coder01"];
    [message addAttributeWithName:@"to" stringValue:self.roomItem.roomJid];
    
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:self.textField.text];
    
    [message addChild:body];
    [messagesArray addObject:message];
    [self.tableView reloadData];
    
    NSLog(@"message: %@",message);
    
    [[XMPPServer sharedInstance].xmppStream sendElement:message];
    [self.textField resignFirstResponder];
}

- (void)receivedNewMessage:(XMPPMessage *)message {
    
    [messagesArray addObject:message];
    [self.tableView reloadData];
}

@end

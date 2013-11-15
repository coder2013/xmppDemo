//
//  ViewController.m
//  XMPP1112
//
//  Created by shuqiong on 11/12/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import "ViewController.h"
#import "XMPPServer.h"
#import "LoginViewController.h"
#import "SQXMPPRoom.h"

@interface ViewController () <IqDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"主界面";
    [XMPPServer sharedInstance].iqDelegate = self;
    
    confrence = @"conference.shuqiong";
    roomsArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    currentRoomIndex = -1;
    
    [self action_RoomList:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (![[XMPPServer sharedInstance] loginWithUserInfo]) {
        
        [self action_login:nil];
    }
}

- (IBAction)action_login:(id)sender {
    
    LoginViewController *loginCtr = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginCtr animated:YES];
}

- (IBAction)action_RoomList:(id)sender {
    
	XMPPIQ *iq = [XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:@"coder01@shuqiong"];
    [iq addAttributeWithName:@"id" stringValue:@"roomList"];
    [iq addAttributeWithName:@"to" stringValue:@"conference.shuqiong"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    
	[iq addChild:query];
    
	[[XMPPServer sharedInstance].xmppStream sendElement:iq];
}

- (IBAction)action_conference:(id)sender {
    
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"];
    
    [iq addAttributeWithName:@"from" stringValue:@"qqw@win7-20130926zd"];
    [iq addAttributeWithName:@"id" stringValue:@"conference"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    [iq addChild:query];
    
    [[XMPPServer sharedInstance].xmppStream sendElement:iq];
}

- (void)roomInfo:(NSString *)roomJid {
    
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:@"coder01@shuqiong"];
    [iq addAttributeWithName:@"id" stringValue:@"roomInfo"];
    [iq addAttributeWithName:@"to" stringValue:roomJid];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    
	[iq addChild:query];
    
	[[XMPPServer sharedInstance].xmppStream sendElement:iq];
}

- (IBAction)action_roominfo:(id)sender {
    
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:@"coder01@shuqiong"];
    [iq addAttributeWithName:@"id" stringValue:@"roomInfo"];
    [iq addAttributeWithName:@"to" stringValue:@"room1@conference.shuqiong"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    
	[iq addChild:query];
    
	[[XMPPServer sharedInstance].xmppStream sendElement:iq];
}

- (void)receivedIq:(XMPPIQ *)xmppIq {
    
    if ([xmppIq.type isEqualToString:@"result"]) {
        
        NSString *infoId = [xmppIq attributeForName:@"id"].stringValue;
        if ([infoId isEqualToString:@"conference"]) {
            
            
        } else if ([infoId isEqualToString:@"roomList"]) {
            
            NSArray *arr = [xmppIq.childElement elementsForName:@"item"];
            for (DDXMLElement *room in arr) {
                NSLog(@"roomJid: %@",[[room attributeForName:@"jid"] stringValue]);
                [self roomInfo:[room attributeForName:@"jid"].stringValue];
            }
            
        } else if ([infoId isEqualToString:@"roomInfo"]) {
            
            SQXMPPRoom *roomItem = [[SQXMPPRoom alloc] init];
            roomItem.roomJid = [xmppIq attributeForName:@"from"].stringValue;
            NSArray *arr = xmppIq.childElement.children;
            for (DDXMLElement *item in arr) {
                if ([item.name isEqualToString:@"identity"]) {
                    roomItem.roomName = [item attributeForName:@"name"].stringValue;
                }
                if ([item.name isEqualToString:@"x"]) {
                    for (DDXMLElement *xItem in item.children) {
                        
                        NSString *varStr = [xItem attributeForName:@"var"].stringValue;
                        if ([varStr isEqualToString:@"muc#roominfo_description"]) {
                            roomItem.description = [xItem elementForName:@"value"].stringValue;
                        }
                        if ([varStr isEqualToString:@"muc#roominfo_subject"]) {
                            roomItem.subject = [xItem elementForName:@"value"].stringValue;
                        }
                        if ([varStr isEqualToString:@"muc#roominfo_occupants"]) {
                            roomItem.occupants = [xItem elementForName:@"value"].stringValue;
                        }
                        if ([varStr isEqualToString:@"muc#roominfo_creationdate"]) {
                            roomItem.creationdate = [xItem elementForName:@"value"].stringValue;
                        }
                    }
                }
            }
            [dataArray addObject:roomItem];
//            NSLog(@"roomInfo: %@",roomItem);
//            NSLog(@"dataArray: %@",dataArray);
        }
    }
}

@end

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
#import "SQXMPPRoomInfoCell.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"

@interface ViewController () <IqDelegate,PresenceDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"主界面";
    [XMPPServer sharedInstance].iqDelegate = self;
    [XMPPServer sharedInstance].presenceDelegate = self;
    
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

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    SQXMPPRoomInfoCell *roomInfoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (roomInfoCell == nil) {
        roomInfoCell = [[NSBundle mainBundle] loadNibNamed:@"SQXMPPRoomInfoCell" owner:self options:nil][0];
    }
    
    SQXMPPRoom *roomItem = dataArray[indexPath.row];
    
    [roomInfoCell.roomImageView setImageWithURL:[NSURL URLWithString:roomItem.subject]];
    roomInfoCell.roomNameLabel.text = roomItem.roomName;
    roomInfoCell.roomDescribeLabel.text = roomItem.descriptionInfo;
    roomInfoCell.roomOccupantsLabel.text = [NSString stringWithFormat:@"%@人在线",roomItem.occupants];
    
    return roomInfoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     /*
         例子 16. Jabber用户进入一个房间(Groupchat 1.0)
         <presence
         from='hag66@shakespeare.lit/pda'
         to='darkcave@macbeth.shakespeare.lit/thirdwitch'/>
      */
    /*
         例子 37. 用户请求不发送历史
         <presence
         from='hag66@shakespeare.lit/pda'
         to='darkcave@chat.shakespeare.lit/thirdwitch'>
         <x xmlns='http://jabber.org/protocol/muc'>
         <history maxchars='0'/>
         </x>
         </presence>
     */
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:@"from" stringValue:@"coder01@shuqiong"];
    
    SQXMPPRoom *roomItem = dataArray[indexPath.row];
    
    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/coder01",roomItem.roomJid]];
    NSLog(@"presenceInfo:%@",presence);
    [[XMPPServer sharedInstance].xmppStream sendElement:presence];
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
    
    [iq addAttributeWithName:@"from" stringValue:@"coder01@shuqiong"];
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
            
            DDXMLElement *xElement = [[xmppIq elementForName:@"query"] elementForName:@"x"];
            NSArray *childElementsArray = [xElement children];
            for (DDXMLElement *childItem in childElementsArray) {
                
                NSString *varStringValue = [childItem attributeForName:@"var"].stringValue;
                if ([varStringValue isEqualToString:@"muc#roominfo_description"]) {
                    roomItem.descriptionInfo = [childItem elementForName:@"value"].stringValue;
                } else if ([varStringValue isEqualToString:@"muc#roominfo_subject"]) {
                    roomItem.subject = [childItem elementForName:@"value"].stringValue;
                } else if ([varStringValue isEqualToString:@"muc#roominfo_occupants"]) {
                    roomItem.occupants = [childItem elementForName:@"value"].stringValue;
                } else if ([varStringValue isEqualToString:@"x-muc#roominfo_creationdate"]) {
                    roomItem.creationdate = [childItem elementForName:@"value"].stringValue;
                }
            }
            [dataArray addObject:roomItem];
            [self.tableView reloadData];
        }
    }
}

- (void)receivedGroupPresence:(XMPPPresence *)presence {
    
    //进入房间之后收到的message 关注!!!
    
    for (SQXMPPRoom *roomItem in dataArray) {
        
        if ([roomItem.roomJid isEqualToString:[NSString stringWithFormat:@"%@@%@",presence.from.user,confrence]]) {
            
            ChatViewController *chatCtr = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            chatCtr.roomItem = roomItem;
            [self.navigationController pushViewController:chatCtr animated:YES];
            break ;
        }
    }
}

- (IBAction)xmlDemo:(id)sender {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"xml" ofType:@"xml"];
//    NSData *xmlData = [NSData dataWithContentsOfFile:path];
//    
//    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
//    
//    DDXMLElement *iqElement = [document rootElement];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XMLDemo" ofType:@"txt"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    DDXMLElement *iqElement = [document rootElement];
    DDXMLElement *queryElement = [iqElement elementForName:@"query"];
    DDXMLElement *xElement = [queryElement elementForName:@"x"];
    
    NSArray *attArray = [iqElement nodesForXPath:@"field" error:nil];
    NSLog(@"feature:+++++++%@",[iqElement nodesForXPath:@"feature" error:nil]);
    NSLog(@"field:-------%@",attArray);
}
@end

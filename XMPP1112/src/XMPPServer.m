//
//  XMPPServer.m
//  XMPP1112
//
//  Created by shuqiong on 11/12/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import "XMPPServer.h"

@implementation XMPPServer

+ (XMPPServer *)sharedInstance {
    
    static XMPPServer *sharedServer;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedServer = [[XMPPServer alloc] init];
    });
    
    return sharedServer;
}

- (void)setupStream {
    
    _xmppStream = [[XMPPStream alloc] init];
    _xmppReconnect = [[XMPPReconnect alloc] init];
    
    [_xmppReconnect activate:_xmppStream];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    
    [self setupStream];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    server = [userDefaults objectForKey:XMPPSERVER];
    port = [userDefaults integerForKey:XMPPPORT];
    jid = [userDefaults objectForKey:XMPPUSERNAME];
    password = [userDefaults objectForKey:XMPPPASSWORD];
    domain = [userDefaults objectForKey:XMPPDOMAIN];
    
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jid == nil || password == nil) {
        return NO;
    }
    
    [_xmppStream setMyJID:[XMPPJID jidWithUser:jid domain:domain resource:nil]];
    [_xmppStream setHostName:server];
    [_xmppStream setHostPort:port];
    
    NSError *error = nil;
    
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        
        NSLog(@"xmpp____connect error,%@",error);
        return NO;
    } else {
        NSLog(@"xmpp____connect ok!");
    }
    return YES;
}

- (void)goOnline {
    
//    XMPPPresence *presence = [XMPPPresence presence];
//    [[self xmppStream] sendElement:presence];
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    [_xmppStream sendElement:presence];
}

- (void)goOffline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (void)disconnect {
    
    [self goOffline];
    [_xmppStream disconnect];
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    
    NSLog(@"willconnect");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    NSLog(@"disconnect: %@",error);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    isOpen = YES;
    [[self xmppStream] authenticateWithPassword:password error:nil];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    [self goOnline];
}

- (void)xmppStreamDidNotAuthenticate:(XMPPStream *)sender {
    
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error {
    
    NSLog(@"redeiveError:%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    if ([message isMessageWithBody] && [message.type isEqualToString:@"groupchat"]) {
        
        [self.messageDelegate receivedNewMessage:message];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    NSLog(@"didReceiveIQ:%@",iq.description);
    [self.iqDelegate receivedIq:iq];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSLog(@"didReceivePresence:%@",presence.description);
    //状态
    NSString *presenceType = [presence type];
    //当前用户
    NSString *userId = [[sender myJID] user];
    //状态用户if
    NSString *presenceFromUser = [[presence from] user];
    
    NSArray *childrenArray = presence.children;
    if (childrenArray.count > 0) {
        for (DDXMLElement *item in childrenArray) {
            if ([item.name isEqualToString:@"x"]) {
                
                NSArray *nameSpaceArray = item.namespaces;
                for (DDXMLElement *nameSpace in nameSpaceArray) {
                    if ([nameSpace.stringValue isEqualToString:@"http://jabber.org/protocol/muc#user"]) {
                        [self.presenceDelegate receivedGroupPresence:presence];
                    }
                }
            }
        }
    }
    
    if ([presenceType isEqualToString:@"available"] && ![userId isEqualToString:presenceFromUser]) {
        
        
    }
}

//判断是否有聊天的登录信息-->goOnline isConnect
- (BOOL)loginWithUserInfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:XMPPDOMAIN].length && [defaults stringForKey:XMPPUSERNAME].length && [defaults stringForKey:XMPPSERVER].length && [defaults stringForKey:XMPPPASSWORD].length;
}

//设置用户登录所需信息
- (void)setupUserInfoName:(NSString *)xmppUserName Password:(NSString *)xmppUserPass Domain:(NSString *)xmppDomain Server:(NSString *)xmppServer Port:(NSInteger)xmppPort{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:xmppDomain forKey:XMPPDOMAIN];
    [defaults setObject:xmppUserName forKey:XMPPUSERNAME];
    [defaults setObject:xmppServer forKey:XMPPSERVER];
    [defaults setObject:xmppUserPass forKey:XMPPPASSWORD];
    [defaults setInteger:xmppPort forKey:XMPPPORT];
    
    [defaults synchronize];
    
    [self connect];
}

@end

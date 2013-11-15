//
//  XMPPServer.h
//  XMPP1112
//
//  Created by shuqiong on 11/12/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#define XMPPSERVER @"XMPP_SERVER"
#define XMPPPORT @"XMPP_PORT"
#define XMPPUSERNAME @"XMPP_USERNAME"
#define XMPPPASSWORD @"XMPP_PASSWORD"
#define XMPPDOMAIN @"XMPP_DOMAIN"

@protocol ChatDelegate <NSObject>

- (void)buddyOnLine:(NSString *)buddyName;
- (void)buddyOffLine:(NSString *)buddyName;

@end

@protocol MessageDelegate <NSObject>

- (void)receivedNewMessage:(NSDictionary *)messagesDict;

@end

@protocol IqDelegate <NSObject>

- (void)receivedIq:(XMPPIQ *)xmppIq;

@end

@interface XMPPServer : NSObject {
    
    NSString *server;
    NSString *domain;
    NSString *password;
    NSString *jid;
    int port;
    BOOL isOpen;
//    XMPPStream *xmppStream;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

@property (nonatomic, weak) id<ChatDelegate> chatDelegate;
@property (nonatomic, weak) id<MessageDelegate> messageDelegate;
@property (nonatomic, weak) id<IqDelegate> iqDelegate;

+ (XMPPServer *)sharedInstance;

- (void)goOnline;
- (void)goOffline;

- (BOOL)loginWithUserInfo;
- (void)setupUserInfoName:(NSString *)xmppUserName Password:(NSString *)xmppUserPass Domain:(NSString *)xmppDomain Server:(NSString *)xmppServer Port:(NSInteger)xmppPort;

@end

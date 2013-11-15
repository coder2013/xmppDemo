//
//  XMPPRoom
//  XMPP1112
//
//  Created by shuqiong on 11/15/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQXMPPRoom : NSObject

@property (nonatomic, strong) NSString *roomJid;
@property (nonatomic, strong) NSString *roomName;

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *occupants;
@property (nonatomic, strong) NSString *creationdate;

@end

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

@property (nonatomic, strong) NSString *descriptionInfo;
@property (nonatomic, strong) NSString *subject;   //subject保存图片
@property (nonatomic, strong) NSString *occupants;
@property (nonatomic, strong) NSString *creationdate;

@end

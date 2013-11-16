//
//  XMPPRoom.m
//  XMPP1112
//
//  Created by shuqiong on 11/15/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import "SQXMPPRoom.h"

@implementation SQXMPPRoom

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",self.roomJid,self.roomName,self.descriptionInfo,self.subject,self.occupants,self.creationdate];
}

@end

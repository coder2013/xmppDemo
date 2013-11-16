//
//  SQXMPPRoomInfoCell.h
//  XMPP1112
//
//  Created by shuqiong on 11/16/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQXMPPRoomInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomOccupantsLabel;

@end

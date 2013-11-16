//
//  ViewController.h
//  XMPP1112
//
//  Created by shuqiong on 11/12/13.
//  Copyright (c) 2013 shuqiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    NSString *confrence;
    NSMutableArray *roomsArray;
    NSMutableArray *dataArray;
    NSInteger currentRoomIndex;
}

- (IBAction)action_login:(id)sender;
- (IBAction)action_RoomList:(id)sender;
- (IBAction)action_conference:(id)sender;
- (IBAction)action_roominfo:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

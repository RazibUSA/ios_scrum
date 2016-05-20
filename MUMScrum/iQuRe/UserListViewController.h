//
//  UserListViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *userList;
@property (nonatomic, retain) NSArray *userStoryID;

-(IBAction)createUser:(id)sender;

@end

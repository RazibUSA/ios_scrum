//
//  UserSelectViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/20/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *userList;
@property (nonatomic, retain) NSMutableDictionary *postDict;
@property (nonatomic, retain) NSString *postUrl;
@property (nonatomic, retain) NSString *targetKey;

@end

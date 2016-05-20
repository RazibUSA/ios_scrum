//
//  BacklogListViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BacklogListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *backlogList;
@property (nonatomic, retain) NSString *projectID;
@property (nonatomic, retain) NSString *sprintID;

-(IBAction)createBacklog:(id)sender;

@end

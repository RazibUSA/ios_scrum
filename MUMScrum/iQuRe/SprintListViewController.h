//
//  SprintListViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SprintListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *sprintList;
@property (nonatomic, retain) NSString *projectID;

-(IBAction)createSprint:(id)sender;

@end

//
//  ProjectListViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *projectList;

-(IBAction)createProject:(id)sender;

@end

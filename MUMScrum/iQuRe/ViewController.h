//
//  ViewController.h
//  iQuRe
//
//  Created by Najmul Hasan on 7/3/14.
//  Copyright (c) 2014 KryKo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class LoginView;
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *btnMangeProject;

@property (nonatomic, retain) LoginView *loginView;
@property (nonatomic, retain) NSArray *userList;
@property (nonatomic, retain) NSArray *projectList;

@end

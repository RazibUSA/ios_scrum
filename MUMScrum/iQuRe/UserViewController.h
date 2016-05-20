//
//  UserViewController.h
//  ReferralHive
//
//  Created by Najmul Hasan on 10/24/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class User;
@class LoginView;
@interface UserViewController : UIViewController<ConnectionManagerDelegate>{
    
    IBOutlet    UIButton       *btnEditProfile;
    IBOutlet    UIButton       *btnSignOut;
    IBOutlet    UIButton       *btnQureHistory;
    IBOutlet    UIButton       *btnQureBank;
    IBOutlet    UIImageView    *proImage;
    
    IBOutlet    UILabel        *lblName;
    IBOutlet    UILabel        *lblEmail;
    IBOutlet    UILabel        *lblAddress;
    
    IBOutlet    UIImageView    *blurImgView;
}

@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;

@property (nonatomic, retain) UIViewController  *parentController;
@property (nonatomic, retain) UIColor           *themeColor;
@property (nonatomic, retain) User              *user;
@property (nonatomic, retain) LoginView         *loginView;

- (void)loadUserData;

- (IBAction)signOutMe:(id)sender;
- (IBAction)editAccountDetails:(id)sender;

@end

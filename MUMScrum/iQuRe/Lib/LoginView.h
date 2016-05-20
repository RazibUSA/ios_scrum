//
//  LoginView.h
//  Bellagio
//
//  Created by Najmul Hasan on 6/21/14.
//  Copyright (c) 2014 Kryko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBKeyboardHandler.h"
#import "STTwitter.h"
#import <FacebookSDK/FacebookSDK.h>

@class RegisterView;
@interface LoginView : UIView<UITextFieldDelegate, KBKeyboardHandlerDelegate, ConnectionManagerDelegate>{

    IBOutlet UIButton *btnSignIn;
    IBOutlet UIButton *btnSignUp;
    
    IBOutlet UITextField *txtFldEmail;
    IBOutlet UITextField *txtFldPassword;
    
    IBOutlet UIView *contentView;
    
    UIImageView *blurView;
    KBKeyboardHandler *keyboard;
    UITapGestureRecognizer *singleTap;
    
    RegisterView *registerView;
    NSDictionary<FBGraphUser> *faceBookUser;
    NSString *twitterUserID;
}

@property (nonatomic, retain) IBOutlet UIButton *btnSkip;
@property (nonatomic, retain) IBOutlet UIButton *btnParentRevealer;
@property (nonatomic, retain) UIViewController *parentController;
@property (nonatomic, strong) STTwitterAPI *twitter;

- (void)showBlurEffect:(UIView *)view;

- (void)showUp;
- (IBAction)closeMe:(id)sender;
- (IBAction)actonSignUp:(id)sender;
- (IBAction)actonSignIn:(id)sender;
- (IBAction)actonRevealParent:(id)sender;
- (IBAction)actionForgetPassword:(id)sender;
- (IBAction)actonVisitUs:(id)sender;

//- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;

@end

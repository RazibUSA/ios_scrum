//
//  LoginView.m
//  Bellagio
//
//  Created by Najmul Hasan on 6/21/14.
//  Copyright (c) 2014 Kryko. All rights reserved.
//

#import "LoginView.h"
#import "UIImage+Blur.h"
#import "ViewController.h"
#import "AnimationManager.h"
#import "UserViewController.h"
#import "FFormViewController.h"
#import "SWRevealViewController.h"
#import "MyWebViewViewController.h"
#import "ViewController.h"
#import "User.h"
#import "Role.h"

#define     ILQueue             dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.frame;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    UIView *infoView = [nibViews objectAtIndex:0];
    infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    infoView.backgroundColor = [UIColor clearColor];
    [self addSubview:infoView];
    contentView.center = self.center;
    
    [btnSignIn makeBorderCornerRadius:5.0
                           withWidth:1.0
                            withColor:[UIColor lightGrayColor]];
    
    [btnSignUp makeBorderCornerRadius:5.0
                           withWidth:1.0
                           withColor:[UIColor lightGrayColor]];
    
    [_btnSkip makeBorderCornerRadius:_btnSkip.frame.size.height/2
                              withWidth:1.0
                              withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
    
    keyboard = [[KBKeyboardHandler alloc] init];
    keyboard.delegate = self;
    singleTap = [[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(dismissKeyboard)];
    
//    [self.layer setBorderWidth:1.0];
//    [self.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)keyboardSizeChanged:(CGSize)delta
{
    if (delta.height>0) {
        [self addGestureRecognizer:singleTap];
    }else{
        [self removeGestureRecognizer:singleTap];
    }
    self.center = CGPointMake(self.center.x, self.center.y - delta.height/2);
}

- (void)dismissKeyboard {
    
    [self endEditing:TRUE];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)showUp{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    [self showBlurEffect:[[window subviews] objectAtIndex:0]];
     [[[window subviews] objectAtIndex:0] addSubview:self];
    [self setHidden:YES];
    [self setAlpha:0.0f];
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setHidden:NO];
        [self setAlpha:1.f];
    } completion:nil];
}

- (void)showBlurEffect:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    blurView = [[UIImageView alloc] initWithFrame:view.frame];
    blurView.image = [image boxblurImageWithBlur:0.2];
//    [self insertSubview:blurView atIndex:0];
    [view insertSubview:blurView belowSubview:self];
}

- (IBAction)actonVisitUs:(id)sender{

    MyWebViewViewController *controller = [[MyWebViewViewController alloc]
                                           initWithNibNameAndWithLinkWithToolbar:@"MyWebViewViewController"
                                           bundle:[NSBundle mainBundle] link:@"http://instaonline.net/websites/iqure/" title:@"iQuRe"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:nav animated:YES completion:^{
    
        [self closeMe:nil];
    }];
}

- (IBAction)closeMe:(id)sender{
    
    [blurView removeFromSuperview];
//    [[AnimationManager sharedInstance] startFadeOut:self];
    [self removeFromSuperview];
    [[DataModel sharedInstance] setPlayedOnce:YES];
}

- (IBAction)actonRevealParent:(id)sender{

    if ([self.parentController isKindOfClass:[UserViewController class]]) {
        UserViewController *controller = (UserViewController*)self.parentController;
        [controller.revealViewController revealToggle:nil];

        [blurView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (IBAction)actonSignUp:(id)sender{

//    if (!registerView) {
//        registerView = [[RegisterView alloc] initWithFrame:self.bounds];
//        [self addSubview:registerView];
//        registerView.parentController = self.parentController;
//        registerView.hidden = YES;
//    }
//    
//    [registerView showBlurEffect:self];
//    [[AnimationManager sharedInstance] startFadeIn:registerView];
    
    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Join Now !";
    formVC.formName = @"SignUpForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    
    formVC.parentController = self.parentController;
    
    [[(ViewController*)self.parentController navigationController] pushViewController:formVC animated:YES];
    
    [self closeMe:nil];
}

- (IBAction)actionForgetPassword:(id)sender{
    
    [self dismissKeyboard];
    [self performSelector:@selector(openForgetPasswordPrompt) withObject:nil afterDelay:0.7];
}

-(void)openForgetPasswordPrompt{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password!" message:@"Please specify your email address. Reset password will be sent to your email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 300;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 300){
        
        NSString *user = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict[@"email"] = user;
            
            NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
            //            postDict[@"token"] = [[DataModel sharedInstance] deviceToken];
            postDict[@"data"] = dict;
            
            
            //        ConnectionManager *connManager = [[ConnectionManager alloc] initWithDelegate:self];
            //        [connManager getServerDataForPost:postDict withUrl:@"/api/users/forgot"];
            
            [SVProgressHUD showProgress:-1 status:@"Please Wait" maskType:SVProgressHUDMaskTypeGradient];
            [[ConnectionManager sharedInstance] JSONRequestWithPost:postDict
                                                            withUrl:@"forgot_password"
                                                            success:^(NSDictionary *JSON) {
                                                                
                                                                NSLog(@"JSON: %@",JSON);
                                                                
                                                                NSString *message = JSON[@"message"];
                                                                [SVProgressHUD showSuccessWithStatus:message];
                                                                NSString *responseCode = JSON[@"status_code"];
                                                                if ([responseCode integerValue] == 200) {
                                                                    
                                                                }
                                                            }
                                                            failure:^(NSError *error, NSDictionary *JSON) {
                                                                [SVProgressHUD dismiss];
                                                            }];
        }
    }
}

-(IBAction)actonSignIn:(id)sender{

//    [self closeMe:nil];
    if (([txtFldEmail.text length] == 0) || ([txtFldPassword.text length] == 0)) {
        [SVProgressHUD showErrorWithStatus:@"User Name or Password is not valid"];
        return;
    }
    
    [self endEditing:TRUE];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:txtFldEmail.text forKey:@"email"];
    [dict setObject:txtFldPassword.text forKey:@"password"];
    
//    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//    [postDict setObject:dict forKey:@"data"];
//    [postDict setObject:[[DataModel sharedInstance] deviceToken] forKey:@"token"];
    

    [SVProgressHUD showProgress:-1 status:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
//    ConnectionManager *connManager = [[ConnectionManager alloc] initWithDelegate:self];
//    [connManager getServerDataForPost:postDict withUrl:@"sign_out"];
    
//    return;
    [[ConnectionManager sharedInstance] JSONRequestWithPost:dict
                                                    withUrl:SIGN_IN
                                                    success:^(NSDictionary *JSON) {
                                                        
                                                        NSLog(@"JSON:%@",JSON);
                                                        NSString *message = JSON [@"statusMessage"][0];
                                                        NSString *responseCode = JSON [@"statusCode"];
                                                        
                                                        if ([responseCode integerValue] == 1) {
                                                            [SVProgressHUD showSuccessWithStatus:message];
                                                            
                                                            [[NSUserDefaults standardUserDefaults] setObject:JSON[@"data"][@"permission"] forKey:@"Permission"];
                                                            [[DataModel sharedInstance] setDeviceToken:JSON[@"data"][@"token"]];
                                                            
                                                            User *user = [[User alloc] initWithDictionary:JSON[@"data"][@"individual"]];
                                                            [user saveUserData];
                                                            if ([self.parentController isKindOfClass:[ViewController class]]) {
                                                                
                                                                ViewController *controller = (ViewController*)self.parentController;

                                                                controller.btnMangeProject.hidden = ([user.role.role_id intValue] == 1);
                                                            }
                                                            
                                                            if ([self.parentController isKindOfClass:[UserViewController class]]) {
                                                                
                                                                UserViewController *controller = (UserViewController*)self.parentController;
                                                                
                                                                [controller loadUserData];
                                                            }
                                                            [self closeMe:nil];
                                                            
                                                        }else{
                                                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
                                                        }
                                                    }
                                                    failure:^(NSError *error, NSDictionary *JSON) {
                                                        [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
                                                    }];
}

-(void)didCompletedFetchData:(NSData*)fetchedData{
    
    if (fetchedData) {
        
        NSError* error;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:fetchedData //1
                                                                 options:kNilOptions
                                                                   error:&error];
        
        NSLog(@"jsonDict :%@",jsonDict);
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error occured please try again"];
        return;
    }
}

@end

//
//  UserViewController.m
//  ReferralHive
//
//  Created by Najmul Hasan on 10/24/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import "UserViewController.h"
#import "SWRevealViewController.h"
#import "FFormViewController.h"
#import "UIImageView+Cached.h"
#import "AnimationManager.h"
#import "UIImage+Blur.h"
#import "LoginView.h"
#import "User.h"
#import "Role.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    blurImgView.image = [blurImgView.image boxblurImageWithBlur:0.5];
//    [proImage makeBorderCornerRadius:proImage.frame.size.height/2 withWidth:6.0 withColor:[UIColor whiteColor]];
    
    [proImage.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [proImage.layer setBorderWidth:1.0f];
    [proImage.layer setMasksToBounds:YES];
    
    
    [btnEditProfile makeBorderCornerRadius:btnEditProfile.frame.size.height/2 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    [btnQureHistory makeBorderCornerRadius:btnQureHistory.frame.size.height/2 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    [btnQureBank makeBorderCornerRadius:btnQureBank.frame.size.height/2 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    [btnSignOut makeBorderCornerRadius:btnSignOut.frame.size.height/2 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];

//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.toolbar setHidden:YES];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self performSelector:@selector(loadUserData) withObject:nil afterDelay:0.5];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController.toolbar setHidden:NO];
    
    self.title = @"";
}

- (void)closeMe
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IgnoreRefresh"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)editAccountDetails:(id)sender{
    
    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Edit Profile";
    formVC.formName = @"Account";
    formVC.user = self.user;
    formVC.isAccount = YES;
    formVC.editableData = [self.user getEditableDict];
    
    [self.navigationController pushViewController:formVC animated:YES];
}

- (void)clearOldUser{
    
    _user = nil;
    [[DataModel sharedInstance] setUserId:nil];
//    [[DataModel sharedInstance] setDeviceToken:nil];
    
    NSString *userFilePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:@"user.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userFilePath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:userFilePath error:nil];
    }
    
    lblName.text = @"";
    lblEmail.text = @"";
    lblAddress.text = @"";
    proImage.image = [UIImage imageNamed:@"photo_default.png"];
    
    self.title = @"Account";
    [self performSelector:@selector(loadUserData) withObject:nil afterDelay:0.5];
}

- (void)loadUserData{
    
    if (![[[DataModel sharedInstance] userId] length]) {
        
        self.title = @"Account";
        if (!_loginView) {
            
            _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
        }
        _loginView.parentController = self;
        _loginView.btnSkip.hidden = YES;
//        _loginView.btnParentRevealer.hidden = NO;
        [_loginView showUp];
        
        return;
    }
    
    NSString *userFilePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:@"user.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userFilePath]) {
        
        _user = [[User alloc] initWithFile];
    }
    
    lblName.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    lblEmail.text = self.user.email;
    lblAddress.text = self.user.role.name;
    
    self.title = self.user.role.name;
    
    proImage.contentMode = UIViewContentModeScaleAspectFill;
//    if ([self.user.photo length]) {
//        
//        [proImage loadFromURL:[NSURL URLWithString:self.user.photo]];
//    }
}

- (void)authenticateUserForToken{
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[[DataModel sharedInstance] deviceToken] forKey:@"token"];
    
    ConnectionManager *connManager = [[ConnectionManager alloc] initWithDelegate:self];
    [connManager getServerDataForPost:postDict withUrl:@"/api/users"];
}

-(void)didCompletedFetchData:(NSData*)fetchedData{
    
    if (fetchedData) {
        
        NSError* error;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:fetchedData //1
                                                                 options:kNilOptions
                                                                   error:&error];
        
        NSLog(@"jsonDict :%@",jsonDict);
        NSString *message = [jsonDict objectForKey:@"message"];
        NSString *responseCode = [jsonDict objectForKey:@"status_code"];
        
        if ([responseCode integerValue] == 200) {
            
            [SVProgressHUD showSuccessWithStatus:@"Sign Out Successfully" maskType:SVProgressHUDMaskTypeGradient];
//            [[DataModel sharedInstance] setUserId:nil];
//            [[DataModel sharedInstance] setDeviceToken:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:message];
            return;
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error occured please try again"];
        return;
    }
}

-(IBAction)signOutMe:(id)sender{
    
    
    [SVProgressHUD showSuccessWithStatus:@"Sign Out Successfully"];
    [self clearOldUser];
    
    return;
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[[DataModel sharedInstance] deviceToken] forKey:@"token"];
    
    [SVProgressHUD showProgress:-1 status:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
//    ConnectionManager *connManager = [[ConnectionManager alloc] initWithDelegate:self];
//    [connManager getServerDataForPost:postDict withUrl:@"sign_out"];
//    return;
    [[ConnectionManager sharedInstance] JSONRequestWithPost:postDict
                                                    withUrl:SIGN_OUT
                                                    success:^(NSDictionary *JSON) {
                                                        
                                                        NSLog(@"JSON:%@",JSON);
                                                        NSString *message = [JSON objectForKey:@"message"];
                                                        NSString *responseCode = [JSON objectForKey:@"status_code"];
                                                        
                                                        if ([responseCode integerValue] == 200) {

                                                            [SVProgressHUD showSuccessWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
                                                            [self clearOldUser];
                                                            
                                                        }else{
                                                            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
                                                        }
                                                    }
                                                    failure:^(NSError *error, NSDictionary *JSON) {
                                                        [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
                                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    UIViewController *viewController = [segue destinationViewController];
//    if ([viewController isKindOfClass:[QureHistoryViewController class]]) {
//        
//        QureHistoryViewController *controller = (QureHistoryViewController*)viewController;
//        controller.user = _user;
//        controller.showDonatedQure = ([segue.identifier isEqualToString:@"ShowQureHistory"]);
//    }
}

@end

//
//  ViewController.m
//  iQuRe
//
//  Created by Najmul Hasan on 7/3/14.
//  Copyright (c) 2014 KryKo. All rights reserved.
//

#import "ViewController.h"
#import "AnimationManager.h"
#import "LoginView.h"
#import "SWRevealViewController.h"
#import "UserListViewController.h"
#import "ProjectListViewController.h"
#import "User.h"
#import "Role.h"


@interface ViewController (){

    IBOutlet UIButton *scanButton;
    IBOutlet UIButton *watchButton;
    IBOutlet UIButton *btnQureBalance;
    IBOutlet UIButton *btnDonatedSoFar;
    
    IBOutlet UIImageView *bgImageView;
    IBOutlet UILabel *lbltopTitle;
    
    BOOL boolToggler;
    CGAffineTransform originalTrnsform;
    
    //Dashboard for System Admin
    IBOutlet UIButton *btnMangeUser;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    originalTrnsform = scanButton.transform;
    
    lbltopTitle.hidden =  YES;
    scanButton.hidden = YES;
    
    [watchButton makeBorderCornerRadius:watchButton.frame.size.height/2
                              withWidth:1.0
                              withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
    
    [_btnMangeProject makeBorderCornerRadius:_btnMangeProject.frame.size.height/2
                              withWidth:8.0
                              withColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
    
    [btnMangeUser makeBorderCornerRadius:btnMangeUser.frame.size.height/2
                                  withWidth:8.0
                                  withColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.toolbar setHidden:NO];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (![[[DataModel sharedInstance] deviceToken] length]){
        [self performSelector:@selector(promtToLoginView) withObject:nil afterDelay:0.7];
    }else {
    
        NSString *userFilePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:@"user.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:userFilePath]) {
            
            User *user = [[User alloc] initWithFile];
            _btnMangeProject.hidden = ([user.role.role_id intValue] == 1);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.title = @"";
}

-(void)pingAnimate{
    
    boolToggler = !boolToggler;
    [UIView animateWithDuration:3.0
                          delay:0.5
         usingSpringWithDamping:1
          initialSpringVelocity:20
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            scanButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                        }
                     completion:^(BOOL finished) {
//                         [self pingAnimate];
                     }];
}

-(void)promtToLoginView{
    
    if (![[[DataModel sharedInstance] deviceToken] length]) {
    
        if (!_loginView) {
            _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
        }
    }
    
    _loginView.parentController = self;
    [_loginView showUp];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
//    if ([segue.identifier isEqual: @"ShowUsers"]){
//    
//        UserListViewController *controller = (UserListViewController*)[segue destinationViewController];
//        controller.userList = [self.userList mutableCopy];
//    }else if ([segue.identifier isEqual: @"ShowProjects"]){
//    
//        ProjectListViewController *controller = (ProjectListViewController*)[segue destinationViewController];
//        controller.projectList = [self.projectList mutableCopy];
//    }
}

- (IBAction)seeReports:(id)sender{
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    dict [@"token"] = [[DataModel sharedInstance] deviceToken];
//    
//    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://mumscrum.cfapps.io/loaddashboard"];
//    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"token" value:[[DataModel sharedInstance] deviceToken]];
//    components.queryItems = @[ search ];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:components.URL];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        NSLog(@"requestReply: %@", requestReply);
//    }] resume];
//    
//    [SVProgressHUD showProgress:-1 status:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
//    
//    [[ConnectionManager sharedInstance] JSONRequestWithMethod:@"GET"
//                                                         body:dict
//                                                      withUrl:@"loaddashboard"
//                                                      success:^(NSDictionary *JSON) {
//                                                          NSLog(@"Success JSON:%@",JSON);
//                                                          [SVProgressHUD showErrorWithStatus:@"Successful"];
//                                                      }
//                                                      failure:^(NSError *error, NSDictionary *JSON) {
//                                                          NSLog(@"Failure JSON:%@",JSON);
//                                                          [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
//                                                      }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

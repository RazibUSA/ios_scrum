//
//  BacklogListViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import "BacklogListViewController.h"
#import "FFormViewController.h"
#import "UserSelectViewController.h"
#import "UserListViewController.h"
#import "LogTimesViewController.h"
#import "BacklogCell.h"

@interface BacklogListViewController (){

    IBOutlet UIButton       *btnAssign;
    IBOutlet UITableView    *myTableView;
    
    NSDictionary *selectedDict;
    NSArray *userList;
}

@end

@implementation BacklogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [btnAssign makeBorderCornerRadius:btnAssign.frame.size.height/2
                              withWidth:1.0
                              withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
    
    [self getUserList];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (_projectID) [self getBacklogList];
    else if (_sprintID) [self getUserStories];
    
    if ([[[DataModel sharedInstance] roleId] intValue] == 2){
        
        btnAssign.hidden = YES;
    }
    
    if ([[[DataModel sharedInstance] roleId] intValue] == 3){
        
        [btnAssign addTarget:self action:@selector(assignDeveloper:) forControlEvents:UIControlEventTouchUpInside];
        [btnAssign setTitle:@"Assign Developer" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if ([[[DataModel sharedInstance] roleId] intValue] == 4){
        
        [btnAssign addTarget:self action:@selector(actionLogTime:) forControlEvents:UIControlEventTouchUpInside];
        [btnAssign setTitle:@"Log Time" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)getBacklogList{ //From project
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,PROJECT_API,_projectID]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data //1
                                                                 options:kNilOptions
                                                                   error:&error];
        NSLog(@"jsonDict: %@",jsonDict);
        dispatch_async(dispatch_get_main_queue(), ^{
    
            _backlogList = jsonDict[@"data"][@"backlogList"];
            [myTableView reloadData];
        });
    
    }] resume];
}

- (void)getUserList{
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://mumscrum.cfapps.io/loaddashboard"];
    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"token" value:[[DataModel sharedInstance] deviceToken]];
    components.queryItems = @[ search ];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:components.URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data //1
                                                                 options:kNilOptions
                                                                   error:&error];
        NSLog(@"jsonDict: %@",jsonDict);
        dispatch_async(dispatch_get_main_queue(), ^{
        
            userList = jsonDict[@"data"][@"userList"];
            [myTableView reloadData];
        });
        
    }] resume];
}

- (void)getUserStories{  //From sprint
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,SPRINT_API,_sprintID]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data //1
                                                                 options:kNilOptions
                                                                   error:&error];
        NSLog(@"jsonDict: %@",jsonDict);
        dispatch_async(dispatch_get_main_queue(), ^{
            _backlogList = jsonDict[@"data"][@"userStoryList"];
            [myTableView reloadData];
        });
        
    }] resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _backlogList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BacklogCell * cell = (BacklogCell*)[tableView dequeueReusableCellWithIdentifier:@"BacklogCell" forIndexPath:indexPath];
    // Configure the cell...
    
    NSDictionary *dict = _backlogList[indexPath.row];
    
    cell.lblTitle.text = dict [@"title"];
    cell.lblDetails.text = [NSString stringWithFormat:@"Estimation: %@",dict [@"estimation"]];

    cell.btnInfo.tag = indexPath.row;
    cell.btnDetails.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedDict = _backlogList[indexPath.row];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(IBAction)createBacklog:(id)sender{

    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Add Backlog";
    formVC.formName = @"BacklogCreateForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    formVC.objectID = _projectID;
    
    formVC.parentController = self;
    
    [self.navigationController pushViewController:formVC animated:YES];
}

- (void)actionLogTime:(id)sender{
    
    NSLog(@"actionLogTime");
    
    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Log Time";
    formVC.formName = @"LogTimeForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    formVC.postDict = [selectedDict mutableCopy];
    
    formVC.parentController = self;
    
    [self.navigationController pushViewController:formVC animated:YES];
}

-(void)assignDeveloper:(id)sender{
    
    if (!selectedDict){
        
        [SVProgressHUD showErrorWithStatus:@"Please select a user story first" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [userList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = (NSDictionary*)obj;
        if ([dict[@"role"][@"id"] intValue] == 4){
            [myArray addObject:dict];
        }
    }];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UserSelectViewController *controller = (UserSelectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UserSelectViewControllerID"];
    controller.userList = myArray;
    controller.postUrl = [NSString stringWithFormat:@"%@/%@",BACKLOG_API,selectedDict[@"id"]];
    controller.postDict = [selectedDict mutableCopy];
    controller.targetKey = @"user";
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"ShowLogTimes"]) {
        
        return ([[[DataModel sharedInstance] roleId] intValue] == 4);
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowDeveloperList"]){
    
        NSDictionary *dict = _backlogList[[sender tag]];
        
        UserListViewController *controller = (UserListViewController*)[segue destinationViewController];
        controller.userStoryID = dict[@"id"];
    }
    if ([segue.identifier isEqualToString:@"ShowLogTimes"]){
       
        NSDictionary *dict = _backlogList[[sender tag]];
        
        LogTimesViewController *controller = (LogTimesViewController*)[segue destinationViewController];
        controller.userStoryID = dict[@"id"];
    }
}

@end

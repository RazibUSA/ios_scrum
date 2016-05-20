//
//  ProjectListViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import "ProjectListViewController.h"
#import "FFormViewController.h"
#import "BacklogListViewController.h"
#import "SprintListViewController.h"
#import "UserSelectViewController.h"
#import "ProjectCell.h"

@interface ProjectListViewController (){

    IBOutlet UIButton       *btnAssign;
    IBOutlet UITableView    *myTableView;
    
    NSDictionary *selectedDict;
    NSMutableArray *userList;
}

@end

@implementation ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    userList = [[NSMutableArray alloc] init];
    [btnAssign makeBorderCornerRadius:btnAssign.frame.size.height/2
                              withWidth:1.0
                              withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    _projectList = [[NSMutableArray alloc] initWithContentsOfFile:[DOC_FOLDER_PATH stringByAppendingPathComponent:PROJECT_LIST_PLIST]];
    
    NSString *btnTitle = @"";
    if ([[[DataModel sharedInstance] roleId] intValue] == 2){
        
        btnTitle = @"Assign Scrum Master";
        [btnAssign addTarget:self action:@selector(assignScrumMaster:) forControlEvents:UIControlEventTouchUpInside];
        [btnAssign setTitle:btnTitle forState:UIControlStateNormal];
    }else{
        
        btnAssign.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self getProjectList];
}

- (void)getProjectList{
    
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
        
            _projectList = jsonDict[@"data"][@"projectList"];
            userList = jsonDict[@"data"][@"userList"];
            
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

    return _projectList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCell * cell = (ProjectCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
    // Configure the cell...
    
    NSDictionary *dict = _projectList[indexPath.row];
    
    cell.lblTitle.text = dict [@"name"];
    cell.lblDetails.text = [NSString stringWithFormat:@"Start Date: %@\nEnd Date: %@",dict [@"startDate"], dict [@"endDate"]];

    cell.btnInfo.tag = indexPath.row;
    cell.btnDetails.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedDict = _projectList[indexPath.row];
}

- (IBAction)actionShowDetails:(id)sender{

    NSDictionary *dict = _projectList[[sender tag]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if ([[[DataModel sharedInstance] roleId] intValue] == 2){
        
        BacklogListViewController *controller = (BacklogListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"BacklogListViewControllerID"];
        controller.projectID = dict[@"id"];
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        
        SprintListViewController *controller = (SprintListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SprintListViewControllerID"];
        controller.projectID = dict[@"id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
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

-(IBAction)createProject:(id)sender{

    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Add Project";
    formVC.formName = @"ProjectCreateForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    
    formVC.parentController = self;
    
    [self.navigationController pushViewController:formVC animated:YES];
}

-(void)assignScrumMaster:(id)sender{
    
    if (!selectedDict){
    
        [SVProgressHUD showErrorWithStatus:@"Please select a project first" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [userList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = (NSDictionary*)obj;
        if ([dict[@"role"][@"id"] intValue] == 3){
            [myArray addObject:dict];
        }
    }];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UserSelectViewController *controller = (UserSelectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UserSelectViewControllerID"];
    controller.userList = myArray;
    controller.postUrl = [NSString stringWithFormat:@"%@/%@",PROJECT_API,selectedDict[@"id"]];
    controller.postDict = [selectedDict mutableCopy];
    controller.targetKey = @"managedBy";
    
    [self.navigationController pushViewController:controller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

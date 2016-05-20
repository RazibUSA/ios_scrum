//
//  SprintListViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import "SprintListViewController.h"
#import "FFormViewController.h"
#import "BacklogListViewController.h"
#import "USSelectViewController.h"
#import "SprintCell.h"

@interface SprintListViewController (){

    IBOutlet UIButton       *btnAssign;
    IBOutlet UITableView    *myTableView;
    
    NSDictionary *selectedDict;
    NSArray *backlogList;
}

@end

@implementation SprintListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [btnAssign makeBorderCornerRadius:btnAssign.frame.size.height/2
                              withWidth:1.0
                              withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getUserStories];
    
    if ([[[DataModel sharedInstance] roleId] intValue] == 3){
        
        [btnAssign addTarget:self action:@selector(assignUserStory:) forControlEvents:UIControlEventTouchUpInside];
        [btnAssign setTitle:@"Assign US to Sprint" forState:UIControlStateNormal];
    }else{
        
        btnAssign.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)getUserStories{
    
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
        
            _sprintList = jsonDict[@"data"][@"sprintList"];
            backlogList = jsonDict[@"data"][@"backlogList"];
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

    return _sprintList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SprintCell * cell = (SprintCell*)[tableView dequeueReusableCellWithIdentifier:@"SprintCell" forIndexPath:indexPath];
    // Configure the cell...
    
    NSDictionary *dict = _sprintList[indexPath.row];
    
    cell.lblTitle.text = dict [@"name"];
    cell.lblDetails.text = [NSString stringWithFormat:@"Start Date: %@\nEnd Date: %@",dict [@"startDate"], dict [@"endDate"]];

    cell.btnInfo.tag = indexPath.row;
    cell.btnDetails.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedDict = _sprintList[indexPath.row];
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

-(IBAction)createSprint:(id)sender{

    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Add Sprint";
    formVC.formName = @"SprintCreateForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    formVC.objectID = _projectID;
    
    formVC.parentController = self;
    
    [self.navigationController pushViewController:formVC animated:YES];
}

- (void)assignUserStory:(id)sender{

    if (!selectedDict){
        
        [SVProgressHUD showErrorWithStatus:@"Please select a sprint first" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    USSelectViewController *controller = (USSelectViewController *)[storyboard instantiateViewControllerWithIdentifier:@"USSelectViewControllerID"];
    controller.userStoryList = [backlogList mutableCopy];
    controller.postUrl = [NSString stringWithFormat:@"%@/%@",SPRINT_API,selectedDict[@"id"]];
    controller.postDict = [selectedDict mutableCopy];
    controller.targetKey = @"userStories";
    controller.isMultiSelect = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSDictionary *dict = _sprintList[[sender tag]];
    
    BacklogListViewController *controller = (BacklogListViewController*)[segue destinationViewController];
    controller.sprintID = dict[@"id"];
}

@end

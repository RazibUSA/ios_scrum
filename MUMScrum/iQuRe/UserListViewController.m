//
//  UserListViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/9/16.
//  Copyright © 2016 KryKo. All rights reserved.
//

#import "UserListViewController.h"
#import "FFormViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (_userStoryID)
        [self getUserListForUS];
    else
        [self getUserList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            _userList = jsonDict[@"data"][@"userList"];
            [self.tableView reloadData];
        });
        
    }] resume];
}

- (void)getUserListForUS{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,BACKLOG_API,_userStoryID]];
    
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
            NSDictionary *dict = jsonDict[@"data"][@"userStoryList"][0][@"user"];
            if (![dict isEqual:[NSNull null]])
                _userList = [NSMutableArray arrayWithObject:dict];
            else {
                
                [SVProgressHUD showErrorWithStatus:@"No developer assigned yet" maskType:SVProgressHUDMaskTypeGradient];
                return ;
            }
            
            [self.tableView reloadData];
        });
        
    }] resume];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _userList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *dict = _userList[indexPath.row];
    NSString *imagename = @[@"sys.png",@"po.png",@"sm.png",@"dev.png"][[dict[@"role"][@"id"] intValue] - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", dict [@"firstName"],dict [@"lastName"]];
    cell.detailTextLabel.text = dict[@"email"];
    
    cell.imageView.image = [UIImage imageNamed:imagename];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
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

-(IBAction)createUser:(id)sender{

    FFormViewController *formVC = [[FFormViewController alloc] initWithStyle:UITableViewStyleGrouped];
    formVC.themeColor = [UIColor whiteColor];
    
    formVC.title = @"Add User";
    formVC.formName = @"SignUpForm";
    formVC.editableData = [[NSMutableDictionary alloc] init];
    
    formVC.parentController = self;
    
    [self.navigationController pushViewController:formVC animated:YES];
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

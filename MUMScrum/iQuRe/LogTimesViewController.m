//
//  LogTimesViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/21/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import "LogTimesViewController.h"

@interface LogTimesViewController (){

    NSArray *logTimeList;
}

@end

@implementation LogTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getLogTimes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLogTimes{

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
            
            logTimeList = jsonDict[@"data"][@"logTimeList"];
            [self.tableView reloadData];
        });
        
    }] resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return logTimeList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogTimeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *dict = logTimeList[indexPath.row];
//    NSString *imagename = @[@"sys.png",@"po.png",@"sm.png",@"dev.png"][[dict[@"role"][@"id"] intValue] - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Worked Hours: %@ Hours", dict [@"lockedTime"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@", dict [@"assignedDate"]];
    
//    cell.imageView.image = [UIImage imageNamed:imagename];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

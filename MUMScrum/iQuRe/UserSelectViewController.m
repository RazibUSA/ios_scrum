//
//  UserSelectViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/20/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import "UserSelectViewController.h"

@interface UserSelectViewController (){

    IBOutlet UIButton       *btnConfirm;
    IBOutlet UITableView    *myTableView;
    
    NSDictionary            *selectedDict;
}

@end

@implementation UserSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [btnConfirm makeBorderCornerRadius:btnConfirm.frame.size.height/2
                            withWidth:1.0
                            withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
    
    [btnConfirm addTarget:self action:@selector(actionConfirmed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    if (!_userList) [self getUserList];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedDict = _userList[indexPath.row];
}

- (void)actionConfirmed:(id)sender{

    _postDict [_targetKey] = @{@"id":selectedDict[@"id"]};
    [[ConnectionManager sharedInstance] JSONRequestWithMethod:@"PUT"
                                                         body:_postDict
                                                      withUrl:_postUrl
                                                      success:^(NSDictionary *JSON) {
                                                          NSLog(@"Success JSON:%@",JSON);
                                                          [SVProgressHUD showSuccessWithStatus:@"Successfully Assigned" maskType:SVProgressHUDMaskTypeGradient];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }
                                                      failure:^(NSError *error, NSDictionary *JSON) {
                                                          NSLog(@"Failure JSON:%@",JSON);
                                                          [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
                                                      }];
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

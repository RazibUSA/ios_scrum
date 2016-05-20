//
//  USSelectViewController.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/20/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import "USSelectViewController.h"
#import "BacklogCell.h"

@interface USSelectViewController (){

    IBOutlet UIButton       *btnConfirm;
    IBOutlet UITableView    *myTableView;
}

@end

@implementation USSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [btnConfirm makeBorderCornerRadius:btnConfirm.frame.size.height/2
                             withWidth:1.0
                             withColor:[APP_THEME_COLOR colorWithAlphaComponent:0.5f]];
    
    [btnConfirm addTarget:self action:@selector(actionConfirmed:) forControlEvents:UIControlEventTouchUpInside];
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
    
    return _userStoryList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BacklogCell * cell = (BacklogCell*)[tableView dequeueReusableCellWithIdentifier:@"BacklogCell" forIndexPath:indexPath];
    // Configure the cell...
    
    NSDictionary *dict = _userStoryList[indexPath.row];
    
    cell.lblTitle.text = dict [@"title"];
    cell.lblDetails.text = [NSString stringWithFormat:@"Estimation: %@",dict [@"estimation"]];
    
    cell.btnInfo.tag = indexPath.row;
    
    return cell;
}

- (void)actionConfirmed:(id)sender{
    
    NSMutableArray *selectedStories = [[NSMutableArray alloc] init];
    
    NSArray *indexs = [myTableView indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSIndexPath *indexPath = (NSIndexPath*)obj;
        NSDictionary *dict = @{@"id" : _userStoryList[indexPath.row][@"id"]};
    
        [selectedStories addObject:dict];
    }];
    
    _postDict [_targetKey] = selectedStories;
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

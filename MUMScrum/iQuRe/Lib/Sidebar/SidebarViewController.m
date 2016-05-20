//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "CategoryCell.h"
#import "UserViewController.h"
#import "StaticViewController.h"
#import "User.h"

@interface SidebarViewController (){
    
    NSArray *leftBarMenus;
    NSDictionary *restaurantStaticData;
    User *user;
    
    IBOutlet UITableView *myTableView;
}
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTableView.sectionFooterHeight = 0;
    myTableView.sectionHeaderHeight = 0;
//    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_2_nomal.png"]]];
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = APP_THEME_COLOR;
    [myTableView setBackgroundView:bview];
    
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 40)];
    footer.textColor = [UIColor lightGrayColor];
    footer.font = [UIFont boldSystemFontOfSize:10];
//    footer.textAlignment = NSTextAlignmentCenter;
    footer.backgroundColor = [UIColor clearColor];
//    footer.text = @"Powered by KryKo Inc.";
    footer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    footer.shadowOffset = CGSizeMake(0, 1);
    
    myTableView.tableFooterView = footer;
    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 38)];
//    title.textColor = [UIColor whiteColor];
//    title.font = [UIFont boldSystemFontOfSize:22.0];
//    title.backgroundColor = [UIColor clearColor];
//    title.text = @"iQuRe";
//   
//    title.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    title.shadowOffset = CGSizeMake(0, 1);
//    
//    self.navigationItem.titleView = title;
    self.isOpen = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadUserData];
    [self showCategoryList];
}

- (void)loadUserData{
    
    NSString *userFilePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:@"user.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userFilePath]) {
        user = [[User alloc] initWithFile];
    }else{
        user = nil;
    }
}

- (void)showCategoryList{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"LeftBarMenu" withExtension:@"plist"];
    leftBarMenus = [[NSArray alloc ] initWithContentsOfURL:url];
    
    url = [[NSBundle mainBundle] URLForResource:@"RestaurantStaticInfo" withExtension:@"plist"];
    restaurantStaticData = [NSDictionary dictionaryWithContentsOfURL:url];
    
    [myTableView reloadData];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [leftBarMenus count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            
            NSDictionary *menu = leftBarMenus [section];
            return [menu[@"Childs"] count]+1;
            return 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menu = leftBarMenus [indexPath.section];
    
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBG_selected.png"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        
        NSString *subMenu = menu[@"Childs"][indexPath.row -1];
        
        cell.arrowImageView.hidden = YES;
        cell.titleLabel.text = subMenu;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_nomal.png"]];
        cell.thumbImageView.image = nil;
    }else{
        
        cell.arrowImageView.hidden = (![menu[@"Childs"] count]);
        cell.titleLabel.text = menu[@"Title"];
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_momal.png"]];
        cell.thumbImageView.image = [UIImage imageNamed:menu[@"Icon"]];
        [cell.thumbImageView.layer setMasksToBounds:YES];
//        [cell.thumbImageView.layer setCornerRadius:cell.thumbImageView.frame.size.height/2];
//        [cell.thumbImageView.layer setMasksToBounds:YES];
        
        if ((indexPath.section==0)&&([user.user_id length])) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
            cell.thumbImageView.image = [UIImage imageNamed:menu[@"Icon"]];
    
            [cell.thumbImageView makeBorderCornerRadius:cell.thumbImageView.frame.size.height/2
                                              withWidth:1.0 withColor:[UIColor whiteColor]];
        }
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
//    NSDictionary *menu = leftBarMenus[indexPath.section];
//    if ([menu[@"Title"] isEqualToString:@"Contact Us"]) {
//        ContactUsView *contactUs = [[ContactUsView alloc] initWithFrame:self.view.bounds];
//        [contactUs showUp];
//    }
    
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
            
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];

            }else{
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
    }else{
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    CategoryCell *cell = (CategoryCell *)[myTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [myTableView beginUpdates];
    
    NSUInteger section = self.selectIndex.section;
    
    NSDictionary *menu = leftBarMenus[section];
    NSUInteger contentCount = [menu[@"Childs"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {
        [myTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [myTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	
	[myTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [myTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [myTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
    NSLog(@"indexPath: %ld",(long)indexPath.row);
    CategoryCell *cell = (CategoryCell *)[myTableView cellForRowAtIndexPath:indexPath];
    if (!cell.arrowImageView.hidden) return;
    
//    if ([segue.identifier isEqualToString:@"ShowFeeds"]) {
//        ViewController *controller = (ViewController*)segue.destinationViewController;
//    }
    
    NSDictionary *menu = leftBarMenus[indexPath.section];
    
    UIViewController *controller = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
  
    if (indexPath.section==0) {
        
        controller = (UserViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UserViewControllerID"];
        if ([user.user_id length]) {
            [(UserViewController *)controller setUser:user];
        }
    }
    
    if ((indexPath.section==2) || (indexPath.section==3)) {
        
        if ([[[DataModel sharedInstance] userId] length]) {
        
//            controller = (QureHistoryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"QureHistoryViewControllerID"];
//            
//            [(QureHistoryViewController *)controller setUser:user];
//            [(QureHistoryViewController *)controller setShowDonatedQure: (indexPath.section==3)];
//            
//            controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
        }else{
            controller = (UserViewController *)[storyboard instantiateViewControllerWithIdentifier:@"UserViewControllerID"];
            if ([user.user_id length]) {
                [(UserViewController *)controller setUser:user];
            }
        }
    }
    
    if ((indexPath.section == 4)||(indexPath.section == 5)) {
        
        controller = (StaticViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StaticViewControllerID"];
        [(StaticViewController *)controller setMyTitle:menu[@"Title"]];
        [(StaticViewController *)controller setDetailText:menu[@"Details"]];
        [(StaticViewController *)controller setWebUrl:@"http://instaonline.net/websites/iqure/about_us.php"];
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {

        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            
            if (controller) {
                [navController setViewControllers: @[controller] animated: NO ];
            }else{
                [navController setViewControllers: @[dvc] animated: NO ];
            }
            
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
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
            
            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:message];
//            NSArray *categoryArray = jsonDict[@"result"];
            [myTableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:message];
            return;
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error occured please try again"];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

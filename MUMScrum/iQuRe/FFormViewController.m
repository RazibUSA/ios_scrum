//
//  FFormViewController.m
//  CrowdAct
//
//  Created by Najmul Hasan on 6/25/14.
//  Copyright (c) 2014 Najmul Hasan. All rights reserved.
//

#import "FFormViewController.h"
#import "UIImageView+Cached.h"
#import "UIImageView+AFNetworking.h"
#import "MyWebViewViewController.h"
#import "UserListViewController.h"
#import "ProjectListViewController.h"
#import "BacklogListViewController.h"
#import "SprintListViewController.h"
#import "UserViewController.h"
#import "UIImage+Blur.h"
#import "CellFormInfo.h"
#import "LoginView.h"

#import "Base64.h"
#import "User.h"

#import <CoreText/CoreText.h>

#define     ILQueue             dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define     CELL_INPUTER        303

@interface FFormViewController (){

    NSArray         *formCellInfos;
    NSArray         *backupFormCellInfos;
    NSIndexPath     *selectedIndex;
    NSMutableArray  *sectionHeaders;
    NSMutableArray  *sectionFooters;
    
    UIButton        *proImage;
    UILabel         *address;
    UILabel         *userName;
    
    KBKeyboardHandler *keyboard;
    CLLocationManager *locationManager;
    CLLocation        *location;
    
    NSString *parent;
    CGRect textCellRect;
    UITapGestureRecognizer *singleTap;
    
    CellFormInfo *locationCellInfo;
    BOOL onlySubmitData;

    UITextField *currentTextField;
}

@end

@implementation FFormViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)makeCellFormInfos:(NSString*)formName {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:formName withExtension:@"plist"];
    NSArray *cellDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:[cellDictionariesArray count]];
    
    for (NSDictionary *sectionDict in cellDictionariesArray) {
        
        NSArray *sectionArray = [sectionDict objectForKey:@"Cells"];
        [sectionHeaders addObject:[sectionDict objectForKey:@"Header"]];
        [sectionFooters addObject:[sectionDict objectForKey:@"Footer"]];
        
        NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:[sectionArray count]];
        for (NSDictionary *cellDict in sectionArray) {
            
            CellFormInfo *eachCellFormInfo = [[CellFormInfo alloc] initWithDictionary:cellDict];
            if ([_editableData[@"id"] length]) {
                
                NSString *value = [NSString stringWithFormat:@"%@",[_editableData objectForKey:eachCellFormInfo.cellKey]];
                if (value.length !=0)
                    eachCellFormInfo.cellValue = [NSString stringWithFormat:@"%@|%@",eachCellFormInfo.cellValue,value];
            }else{
                
                NSArray *values = [eachCellFormInfo.cellValue componentsSeparatedByString:@"|"];
                [_editableData setValue:[values objectAtIndex:[values count]-1] forKey:eachCellFormInfo.cellKey];
            }
            
            [cellArray addObject:eachCellFormInfo];
        }
        [infoArray addObject:cellArray];
    }
    if (!formCellInfos) {
        formCellInfos = [[NSArray alloc] init];
        backupFormCellInfos = [[NSArray alloc] init];
    }
    formCellInfos = infoArray;
    backupFormCellInfos = infoArray;
    
    NSLog(@"formCellInfos:%@  Cout: %lu",formCellInfos,(unsigned long)[formCellInfos count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView* bview = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    bview.image = [[UIImage imageNamed:@"background.png"] boxblurImageWithBlur:0.9];
//    [self.tableView setBackgroundView:bview];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    
    if (_isPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCloseMe:)];
    }
    
    if ((!_editableData)||([_editableData[@"id"] isEqual:@"NULL"])) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(actionDoneMe:)];
    }else{
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionDoneMe:)];
    }
    
    if (self.isReadOnly) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    sectionHeaders = [[NSMutableArray alloc] init];
    sectionFooters = [[NSMutableArray alloc] init];
    
    if ([formCellInfos count] == 0)
    {
        [self makeCellFormInfos:self.formName];
    }
    
    keyboard = [[KBKeyboardHandler alloc] init];
    keyboard.delegate = self;
    
    singleTap = [[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(dismissKeyboard)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.tableView reloadData];
    
    if ([self.title isEqualToString:@"Create User"]) {
        address.text = [sectionHeaders objectAtIndex:0];
        address.frame = CGRectMake(125, 15, self.view.frame.size.width - 135, 90);
    }
    
    NSLog(@"_editableData:%@",_editableData);
}

- (void)actionCloseMe:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IgnoreRefresh"];

    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionDoneMe:(id)sender{
    
    NSLog(@"actionDoneMe");
    [self.view endEditing:TRUE];
    
    _editableData = [self getPreparedPostDict];
    if (!_editableData) return;

    NSString *url = nil;

    if ([self.title isEqualToString:@"Edit Profile"]) {
        url = PROFILE;
    }
    
    if ([self.title isEqualToString:@"Add User"]){
    
        url = ADD_USER;
        _editableData[@"role"] = @{@"id" : @([_editableData[@"role"] intValue] + 1)};
        [_editableData removeObjectForKey:@"confirm_password"];
    }
    
    if ([self.title isEqualToString:@"Add Project"]){
        
        url = PROJECT_API;
        _editableData[@"owner"] = @{@"id" : [[DataModel sharedInstance] userId]};
    }
    
    if ([self.title isEqualToString:@"Add Backlog"]){
        
        url = BACKLOG_API;
        _editableData[@"project"] = @{@"id" : _objectID};
    }
    
    if ([self.title isEqualToString:@"Add Sprint"]){
        
        url = SPRINT_API;
        _editableData[@"project"] = @{@"id" : _objectID};
    }
    
    if ([self.title isEqualToString:@"Log Time"]){
    
        url = [NSString stringWithFormat:@"%@/%@",BACKLOG_API,_postDict[@"id"]];
        _postDict [@"logTimes"] = @[_editableData];
        
        [[ConnectionManager sharedInstance] JSONRequestWithMethod:@"PUT"
                                                             body:_postDict
                                                          withUrl:url
                                                          success:^(NSDictionary *JSON) {
                                                              NSLog(@"Success JSON:%@",JSON);
                                                              [SVProgressHUD showSuccessWithStatus:@"Recorded Successfully" maskType:SVProgressHUDMaskTypeGradient];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }
                                                          failure:^(NSError *error, NSDictionary *JSON) {
                                                              NSLog(@"Failure JSON:%@",JSON);
                                                              [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
                                                          }];
        
        return;
    }
    
//    if (![_editableData[@"password"] isEqualToString:_editableData[@"confirm_password"]]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"Confirm Password did not match"];
//        return;
//    }
    
    NSLog(@"_editableData:%@",_editableData);
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[[DataModel sharedInstance] deviceToken] forKey:@"token"];
    [postDict setObject:_editableData forKey:@"data"];
    
//    ConnectionManager *connManager = [[ConnectionManager alloc] initWithDelegate:self];
//    [connManager getServerDataForPost:_editableData withUrl:url];
//    return;
    
    [SVProgressHUD showProgress:-1 status:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    [[ConnectionManager sharedInstance] JSONRequestWithPost:_editableData
                                                    withUrl:url
                                                    success:^(NSDictionary *JSON) {
                                                        
                                                        NSLog(@"Success JSON: %@",JSON);
                                                        NSString *message = JSON [@"statusMessage"][0];
                                                        NSString *responseCode = JSON [@"statusCode"];
                                                        
                                                        if ([responseCode integerValue] == 1) {
                                                        
                                                            [SVProgressHUD showSuccessWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
                                                            [self actionCloseMe:nil];
                                                            
                                                        }else{
                                                            
                                                            [SVProgressHUD showErrorWithStatus:message];
                                                        }
                                                    }
                                                    failure:^(NSError *error, NSDictionary *JSON) {
                                                        [SVProgressHUD showErrorWithStatus:@"An error occured please try again"];
                                                    }];
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
            
    
        }else{
            
            [SVProgressHUD showErrorWithStatus:message];
            return;
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Error occured please try again"];
        return;
    }
}

-(NSMutableDictionary*)getPreparedPostDict{

    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithDictionary:_editableData];
    
    __block BOOL needValidData = NO;
    [formCellInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *groups = (NSArray*)obj;
        [groups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            CellFormInfo *cellFormInfo = (CellFormInfo*)obj;
            NSLog(@"cellFormInfo.cellValue:%@",cellFormInfo.cellValue);
            NSArray *values = [cellFormInfo.cellValue componentsSeparatedByString:@"|"];
            if ([values count]>1) {
                
                [postDict setValue:[values objectAtIndex:[values count]-1] forKey:cellFormInfo.cellKey];
            }else{
                [postDict setValue:@"" forKey:cellFormInfo.cellKey];
            }
            if ([cellFormInfo.cellName hasSuffix:@"*"]&&[postDict[cellFormInfo.cellKey] isEqualToString:@""]) {
                
                NSString *message = [NSString stringWithFormat:@"%1$@ Can't be empty. Please provide %1$@",cellFormInfo.cellName];
                if ([cellFormInfo.cellKey isEqualToString:@"terms_condition"]) {
                    message = [NSString stringWithFormat:@"You must agree terms and condition"];
                }
                
                needValidData = YES;
                [SVProgressHUD showErrorWithStatus:message];
                *stop = YES;
            }
        }];
    }];
    
    NSLog(@"Data to be Submit:%@",postDict);
    if (needValidData) { return nil;}
    return postDict;
}

- (void)keyboardSizeChanged:(CGSize)delta
{
    if (delta.height>0) {
        [self.view addGestureRecognizer:singleTap];
    }else{
        [self.view removeGestureRecognizer:singleTap];
    }
    
    if (textCellRect.origin.y>self.view.center.y) {
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - delta.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [formCellInfos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [formCellInfos [section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if ([self.title isEqualToString:@"Create User"]) {
        return nil;
    }
    return [sectionHeaders objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return [sectionFooters objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
        tableViewHeaderFooterView.textLabel.textColor = APP_THEME_COLOR;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFormInfo *cellFormInfo = formCellInfos [indexPath.section] [indexPath.row];
    if ([cellFormInfo.cellType isEqualToString:@"TextView"]) {
        
        UITextView *_textView = [[UITextView alloc] initWithFrame:CGRectMake(110, 13, 200, 22)];
        _textView.font = [UIFont systemFontOfSize:12.0];
        _textView.text = cellFormInfo.cellValue;
        
        CGRect frame = _textView.frame;
        frame.size.height = _textView.contentSize.height;
        _textView.frame = frame;
        
        return 95;//_textView.contentSize.height + 10;
    }
    
    if ([[NSArray arrayWithObjects:@"SelectOne",@"MultipleSelect",@"Progress", nil] containsObject:cellFormInfo.cellType]) {
        
        return 66;
    }
    
    return [self.tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    CellFormInfo *cellFormInfo = formCellInfos [section] [indexPath.row];
    if ([cellFormInfo.cellType isEqualToString:@"Preview"]) {
        return;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = APP_THEME_COLOR;
    cell.detailTextLabel.textColor = APP_THEME_COLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    CellFormInfo *cellFormInfo = formCellInfos [section] [indexPath.row];
    
    if ([@[@"TextField",@"Password",@"Number",@"Phone"] containsObject:cellFormInfo.cellType]){
        return [self cellForTextFieldWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"TextView"]) {
        return [self cellForTextViewWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"DatePicker"]) {
        return [self cellForDatePickerWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"Segment"]) {
        return [self cellForSegmentWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"Switch"]) {
        return [self cellForSwitchWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"TermSwitch"]) {
        return [self cellForTermSwitchWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"ReadOnly"]) {
        return [self cellForReadOnlyFieldWithInfo:cellFormInfo];
    }
    
    if ([cellFormInfo.cellType isEqualToString:@"Preview"]) {
        return [self cellForPreviewWithInfo:cellFormInfo];
    }
    
    return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndex = indexPath;
    CellFormInfo *cellFormInfo = formCellInfos [indexPath.section] [indexPath.row];
    
    if ([cellFormInfo.cellType isEqualToString:@"TermSwitch"]) {
        [self actionShowTerms];
    }
}

#pragma mark - Cell Generators

- (UITableViewCell *)blankCell
{
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (UITableViewCell *)cellForTextFieldWithInfo:(CellFormInfo*)info
{
    
    UITableViewCell *cell = [self blankCell];
    cell.textLabel.text = info.cellName;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    float offset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) offset = 90;
    else  offset = 20;
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(100 + offset, 7, 185, 30)];
    [cell addSubview:txtField];
    txtField.delegate = self;
    txtField.clearButtonMode = YES;
    txtField.font = [UIFont boldSystemFontOfSize:12.0];
    txtField.returnKeyType = UIReturnKeyDone;
    txtField.tag = CELL_INPUTER;
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    
    txtField.layer.cornerRadius=8.0f;
    txtField.layer.masksToBounds=YES;
    txtField.layer.borderColor=[APP_THEME_COLOR CGColor];
    txtField.layer.borderWidth= 1.0f;
    
//    txtField.textColor = [UIColor whiteColor];
    
    if ([info.cellType isEqualToString:@"Password"]) {
        txtField.secureTextEntry = YES;
//        txtField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if ([info.cellType isEqualToString:@"Number"]) {
        txtField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([info.cellType isEqualToString:@"Phone"]) {
//        txtField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    NSArray *values = [info.cellValue componentsSeparatedByString:@"|"];
    if ([values count]>1) {
        txtField.text = [values objectAtIndex:1];
    }else{
        txtField.placeholder = [values objectAtIndex:0];
    }
    
//    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(90 + offset,0, 0.5, [self.tableView rowHeight])];
//    barView.backgroundColor = [UIColor lightGrayColor];
//    [cell addSubview:barView];
    
    return cell;
}

- (UITableViewCell *)cellForTextViewWithInfo:(CellFormInfo*)info
{
    UITableViewCell *cell = [self blankCell];
    
    cell.textLabel.text = info.cellName;
    
    NSArray *values = [info.cellValue componentsSeparatedByString:@"|"];
    if ([values count]>1) {
        info.cellValue = [values objectAtIndex:1];
    }else{
        info.cellValue = [values objectAtIndex:0];
    }
    
    float offset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) offset = 90;
    else  offset = 20;
    
    UITextView *_textView = [[UITextView alloc] initWithFrame:CGRectMake(100 + offset, 5, 200, 90)];
    _textView.font = [UIFont systemFontOfSize:12.0];
    _textView.text = info.cellValue;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [cell addSubview:_textView];
    
    CGRect frame = _textView.frame;
    frame.size.height = _textView.contentSize.height;
    _textView.frame = frame;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(90 + offset,0, 0.5, 95)];
    barView.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:barView];
    
    return cell;
}

- (UITableViewCell *)cellForSegmentWithInfo:(CellFormInfo*)info
{
    
    UITableViewCell *cell = [self blankCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = info.cellName;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSLog(@"cellForSegmentWithInfo CellValue: %@",info.cellValue);
    
    NSArray *vales = [info.cellValue componentsSeparatedByString:@"|"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[[vales objectAtIndex:0] componentsSeparatedByString:@","]];
    [segment addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = APP_THEME_COLOR;
    
    int selectedIndexNo = 0;
    
    if ([vales count] >2) {
        selectedIndexNo = (int)[[[vales objectAtIndex:1] componentsSeparatedByString:@","] indexOfObject:[vales lastObject]];
    }
    
    segment.selectedSegmentIndex = selectedIndexNo;
    cell.accessoryView = segment;
    
    return cell;
}

- (UITableViewCell *)cellForDatePickerWithInfo:(CellFormInfo*)info
{
    UITableViewCell *cell = [self cellForTextFieldWithInfo:info];
    
    UITextField *txtField = (UITextField*)[cell viewWithTag:CELL_INPUTER];
    [[txtField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
//    [datePicker setMaximumDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(dateDidSelected:) forControlEvents:UIControlEventValueChanged];
    txtField.inputView = datePicker;
    
    return cell;
}

- (UITableViewCell *)cellForSwitchWithInfo:(CellFormInfo*)info
{
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = info.cellName;
    cell.detailTextLabel.numberOfLines = 2;
    
    [info print];
    
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tintColor = APP_THEME_COLOR;
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (([[info.cellValue componentsSeparatedByString:@"|"] count] >1 )) {
        sw.on = [[[info.cellValue componentsSeparatedByString:@"|"] objectAtIndex:1] integerValue];
    }else{
        sw.on = 0;
    }
    cell.accessoryView = sw;
    
    return cell;
}

- (UITableViewCell *)cellForTermSwitchWithInfo:(CellFormInfo*)info
{
    UITableViewCell *cell = [self cellForSwitchWithInfo:info];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:info.cellName];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    cell.detailTextLabel.attributedText = attString;
    cell.detailTextLabel.textColor = APP_THEME_COLOR;
    
    return cell;
}

- (UITableViewCell *)cellForReadOnlyFieldWithInfo:(CellFormInfo*)info
{
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = info.cellName;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSArray *values = [info.cellValue componentsSeparatedByString:@"|"];
    if ([values count]>1) {
        cell.detailTextLabel.text = [values objectAtIndex:1];
    }else{
        cell.detailTextLabel.text = [values objectAtIndex:0];
    }
    
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (UITableViewCell *)cellForPreviewWithInfo:(CellFormInfo*)info
{
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [info.cellName componentsSeparatedByString:@"|"][0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)switchValueChanged:(id)sender{
    
    UISwitch *swtch = (UISwitch*)sender;
    UITableViewCell *cell = [self getSuperViewCell:sender];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CellFormInfo *cellFormInfo = formCellInfos [index.section] [index.row];

    NSArray *values = [cellFormInfo.cellValue componentsSeparatedByString:@"|"];
    cellFormInfo.cellValue = [NSString stringWithFormat:@"%@|%d",[values objectAtIndex:0],swtch.on];
    if ([cellFormInfo.cellType isEqualToString:@"TermSwitch"] && !swtch.on) {
        cellFormInfo.cellValue = @"";
    }
    
    [cellFormInfo print];
}

-(UITableViewCell*)getSuperViewCell:(id)sender{
    
    UITableViewCell *feedCell = nil;
    feedCell = (UITableViewCell*)[sender superview];
    if ([feedCell isKindOfClass:[UITableViewCell class]]) {
        return feedCell;
    }else{
        return [self getSuperViewCell:feedCell];
    }
}

- (void)segmentedValueChanged:(id)sender{
    
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    UITableViewCell *cell = [self getSuperViewCell:sender];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CellFormInfo *cellFormInfo = formCellInfos [index.section] [index.row];
    
    NSArray *values = [cellFormInfo.cellValue componentsSeparatedByString:@"|"];
    NSString *selectedCode = [[[values objectAtIndex:1] componentsSeparatedByString:@","] objectAtIndex:segment.selectedSegmentIndex];
    cellFormInfo.cellValue = [NSString stringWithFormat:@"%@|%@|%@",[values objectAtIndex:0],[values objectAtIndex:1],selectedCode];
    
//    if ([cellFormInfo.cellKey isEqualToString:@"reward"]) {
//        
//        if (segment.selectedSegmentIndex) {
//            NSMutableArray *temp = [backupFormCellInfos mutableCopy];
//            [temp removeObjectAtIndex:1];
//            formCellInfos = temp;
//        }else{
//            formCellInfos = backupFormCellInfos;
//        }
//        [self.tableView reloadData];
//    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    currentTextField = textField;
    
    UITableViewCell *cell = [self getSuperViewCell:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CGRect myRect = [self.tableView rectForRowAtIndexPath:indexPath];
    textCellRect = [self.tableView convertRect:myRect toView:[self.tableView superview]];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (![textField.text length]) {
        textField.text = @"";
    }
    UITableViewCell *cell = [self getSuperViewCell:textField];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CellFormInfo *cellFormInfo = formCellInfos [index.section] [index.row];
    
    cellFormInfo.cellValue = [NSString stringWithFormat:@"%@|%@",[[cellFormInfo.cellValue componentsSeparatedByString:@"|"] objectAtIndex:0],textField.text];
    NSLog(@"cellFormInfo.cellValue:%@",cellFormInfo.cellValue);
    [self.tableView reloadData];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    UITableViewCell *cell = [self getSuperViewCell:textView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CGRect myRect = [self.tableView rectForRowAtIndexPath:indexPath];
    textCellRect = [self.tableView convertRect:myRect toView:[self.tableView superview]];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    if (![textView.text length]) {
        textView.text = @"";
    }
    UITableViewCell *cell = [self getSuperViewCell:textView];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CellFormInfo *cellFormInfo = formCellInfos [index.section] [index.row];
    cellFormInfo.cellValue = textView.text;
    
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)dateDidSelected:(id)sender{

    UIDatePicker *datePicker = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    currentTextField.text = [dateFormatter stringFromDate:datePicker.date];
//    currentTextField.text = [NSDateFormatter localizedStringFromDate:datePicker.date
//                                                           dateStyle:NSDateFormatterMediumStyle
//                                                           timeStyle:NSDateFormatterNoStyle];
//    [currentTextField resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [proImage setImage:image forState:UIControlStateNormal];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        [Base64 initialize];
        NSString *strEncoded = [Base64 encode:imageData];
        [_editableData setValue:strEncoded forKey:@"image"];
        NSLog(@"_editableData:%@",_editableData);
    }];
}

-(void)chooseImage:(id)sender{
    
    NSLog(@"browseFile");
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.allowsEditing = YES;
    pickerVC.delegate = self;
    
    [self.navigationController presentViewController:pickerVC animated:YES completion:^{}];
}

-(void)actionShowTerms{
    
//    Old way
//    NSString *txtFilePath = [[NSBundle mainBundle] pathForResource:@"TermsPrivacyPolicy" ofType:@"txt"];
//    NSString *terms_conditions = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:nil];
   
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TERMS OF USE" message:terms_conditions delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//   
//    UILabel *theBody = [alert valueForKey:@"_bodyTextLabel"];
//    [theBody setTextColor:[UIColor redColor]];
//    
//    [alert show];
    
//    New way
    MyWebViewViewController *controller = [[MyWebViewViewController alloc]
                                           initWithNibNameAndWithLinkWithToolbar:@"MyWebViewViewController"
                                           bundle:[NSBundle mainBundle] link:@"http://instaonline.net/websites/iqure2/terms-of-use/" title:@"iQuRe"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)dismissKeyboard {
    
    [self.view endEditing:TRUE];
}

@end

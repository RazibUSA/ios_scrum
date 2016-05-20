//
//  FFormViewController.h
//  CrowdAct
//
//  Created by Najmul Hasan on 6/25/14.
//  Copyright (c) 2014 Najmul Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KBKeyboardHandler.h"

@class User;
@interface FFormViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KBKeyboardHandlerDelegate, ConnectionManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) UIViewController *parentController;

@property (nonatomic, retain) NSMutableDictionary *editableData;
@property (nonatomic, retain) NSMutableDictionary *postDict; //Only for log time entry
@property (nonatomic, retain) User         *user;
@property (nonatomic, retain) NSString     *post;
@property (nonatomic, retain) NSString     *formName;
@property (nonatomic, retain) UIColor      *themeColor;
@property (nonatomic, retain) NSString     *objectID;

@property (nonatomic) BOOL isReadOnly;
@property (nonatomic) BOOL isAccount;
@property (nonatomic) BOOL isPresented;

@end

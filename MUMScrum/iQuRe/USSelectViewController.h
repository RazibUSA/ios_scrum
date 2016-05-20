//
//  USSelectViewController.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/20/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSelectViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *userStoryList;
@property (nonatomic, retain) NSMutableDictionary *postDict;
@property (nonatomic, retain) NSString *postUrl;
@property (nonatomic, retain) NSString *targetKey;
@property (nonatomic) BOOL isMultiSelect;

@end

//
//  ProjectCell.h
//  MUMScrum
//
//  Created by Najmul Hasan on 7/7/14.
//  Copyright (c) 2016 Kryko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *btnDetails;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDetails;
@property (nonatomic, retain) IBOutlet UIButton *btnInfo;

@end

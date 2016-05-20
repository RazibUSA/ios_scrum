//
//  SprintCell.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/20/16.
//  Copyright © 2016 Instalogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SprintCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *btnDetails;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblDetails;
@property (nonatomic, retain) IBOutlet UIButton *btnInfo;

@end

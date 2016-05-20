//
//  StaticViewController.h
//  Bellagio
//
//  Created by Najmul Hasan on 9/20/14.
//  Copyright (c) 2014 Kryko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticViewController : UIViewController<UIWebViewDelegate>{

    IBOutlet    UIImageView     *blurImgView;
    
    IBOutlet    UILabel         *lblTitle;
    IBOutlet    UITextView      *txtViewDetails;
    IBOutlet    UIWebView       *myWebView;
}

@property (nonatomic, retain) NSString *myTitle;
@property (nonatomic, retain) NSString *detailText;
@property (nonatomic, retain) NSString *webUrl;

@end

//
//  MyWebViewViewController.h
//  Impul-Project
//
//  Created by Huq Majharul on 11/29/12.
//
//

#import <UIKit/UIKit.h>

@interface MyWebViewViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate, UIScrollViewDelegate>
{
    IBOutlet    UIToolbar                   *toolbarBottom;
    IBOutlet    UIWebView                   *myWebView;
    
    
    IBOutlet    UIBarButtonItem             *btnGoBack;
    IBOutlet    UIBarButtonItem             *btnGoNext;
    IBOutlet    UIActivityIndicatorView     *indicatorView;
    IBOutlet    UIView                      *fakeStatusBar;
    
    BOOL        doShowToolbar;
    float       lastOffsetY;
    NSString    *strUrlLink;
}

@property (nonatomic, retain) NSString  *strUrlLink;

-(id)initWithNibNameAndWithLinkWithToolbar:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil link:(NSString*)urlLink title:(NSString*)title_;
-(id)initWithNibNameAndWithLinkNoToolbar:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil link:(NSString*)urlLink title:(NSString*)title_;

-(IBAction)actionGoBack:(id)sender;
-(IBAction)actionGoNext:(id)sender;
-(IBAction)actionDoAction:(id)sender;
-(IBAction)actionCloseMe:(id)sender;

@end

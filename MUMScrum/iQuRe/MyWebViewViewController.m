//
//  MyWebViewViewController.m
//  Impul-Project
//
//  Created by Huq Majharul on 11/29/12.
//
//

#import "MyWebViewViewController.h"
#import "AnimationManager.h"

@interface MyWebViewViewController ()

@end

@implementation MyWebViewViewController
@synthesize strUrlLink;

-(id)initWithNibNameAndWithLinkWithToolbar:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil link:(NSString*)urlLink title:(NSString*)title_
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = title_;
        self.strUrlLink = urlLink;
        doShowToolbar = YES;
    }
    return self;

}

-(id)initWithNibNameAndWithLinkNoToolbar:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil link:(NSString*)urlLink title:(NSString*)title_
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = title_;
        self.strUrlLink = urlLink;
        doShowToolbar = NO;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if TARGET_IPHONE_SIMULATOR
    indicatorView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
#endif
    
    toolbarBottom.hidden = !doShowToolbar;
    if (!doShowToolbar) {
        CGRect frame = myWebView.frame;
        frame.size.height += 44;
        myWebView.frame = frame;
    }
    
    myWebView.opaque = NO;
    myWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.strUrlLink];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:requestObj];
    btnGoBack.enabled = [myWebView canGoBack];
    btnGoNext.enabled = [myWebView canGoForward];
    
    myWebView.scrollView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (myWebView != nil) 
        [myWebView stopLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    indicatorView.hidden = YES;
    [indicatorView stopAnimating];
    btnGoBack.enabled = [myWebView canGoBack];
    btnGoNext.enabled = [myWebView canGoForward];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    indicatorView.hidden = YES;
    [indicatorView stopAnimating];
    btnGoBack.enabled = [myWebView canGoBack];
    btnGoNext.enabled = [myWebView canGoForward];
}

-(IBAction)actionGoBack:(id)sender
{
    [myWebView goBack];
}

-(IBAction)actionGoNext:(id)sender
{
    [myWebView goForward];
}

-(IBAction)actionDoAction:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil otherButtonTitles:@"Open With Safari", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showFromToolbar:toolbarBottom];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrlLink]];
    }
}

-(IBAction)actionCloseMe:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IgnoreRefresh"];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastOffsetY = scrollView.contentOffset.y;
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    bool hide = (scrollView.contentOffset.y > lastOffsetY);
    [[self navigationController] setNavigationBarHidden:hide animated:YES];
    
//    [[AnimationManager sharedInstance] doBottomViewAnimation:toolbarBottom show:hide];
    toolbarBottom.hidden = hide;
    fakeStatusBar.hidden = !hide;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  StaticViewController.m
//  Bellagio
//
//  Created by Najmul Hasan on 9/20/14.
//  Copyright (c) 2014 Kryko. All rights reserved.
//

#import "StaticViewController.h"
#import "SWRevealViewController.h"
#import "UIImage+Blur.h"

@interface StaticViewController ()

@end

@implementation StaticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    blurImgView.image = [blurImgView.image boxblurImageWithBlur:0.2];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = self.myTitle;
    if (([self.myTitle isEqualToString:@"Where to Find Q's"])||([self.myTitle isEqualToString:@"How It Works"])) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
    }
    
    [self.navigationController.toolbar setHidden:YES];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    txtViewDetails.text = self.detailText;
    
    myWebView.opaque = NO;
    myWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:_webUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:requestObj];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AppDelegate.m
//  iQuRe
//
//  Created by Najmul Hasan on 7/3/14.
//  Copyright (c) 2014 KryKo. All rights reserved.
//

#import "AppDelegate.h"
#import "RNCachingURLProtocol.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "SWRevealViewController.h"
#import "UserViewController.h"
#import "ViewController.h"
#import "LoginView.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    UIImage *navBarBackgroundImage = [UIImage imageNamed:@"topBar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont boldSystemFontOfSize:22], NSFontAttributeName, nil]];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //For iOS 8
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]]; //For Less than iOS 8

    [[DataModel sharedInstance] setDeviceToken:nil];
    [[DataModel sharedInstance] setUserId:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"[url scheme]:%@",[url scheme]);
    if ([[url scheme] isEqualToString:@"fb1468981223314805"]) {
        
        BOOL urlWasHandled =
        [FBAppCall handleOpenURL:url
               sourceApplication:sourceApplication
                 fallbackHandler:
         ^(FBAppCall *call) {
             // Parse the incoming URL to look for a target_url parameter
             NSString *query = [url query];
             NSDictionary *params = [self parseURLParams:query];
             // Check if target URL exists
             NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
             if (appLinkDataString) {
                 NSError *error = nil;
                 NSDictionary *applinkData =
                 [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:0
                                                   error:&error];
                 if (!error &&
                     [applinkData isKindOfClass:[NSDictionary class]] &&
                     applinkData[@"target_url"]) {
                     self.refererAppLink = applinkData[@"referer_app_link"];
                     NSString *targetURLString = applinkData[@"target_url"];
                     // Show the incoming link in an alert
                     // Your code to direct the user to the
                     // appropriate flow within your app goes here
                     [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                 message:targetURLString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil] show];
                 }
             }
         }];
        return urlWasHandled;
        
    }else if ([[url scheme] isEqualToString:@"iquretwitter"]){
        
        NSArray  *params = [[url absoluteString] componentsSeparatedByString:@"/"];
        NSString *postType = params [2];
        
        NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
        
        NSString *token = d[@"oauth_token"];
        NSString *verifier = d[@"oauth_verifier"];
        
        if (token) {
            
            SWRevealViewController *revealViewController = (SWRevealViewController*)[self topViewController];
            UINavigationController *nav = (UINavigationController*)revealViewController.frontViewController;
            UIViewController *controller = nav.topViewController;
            
            if ([postType isEqualToString:@"twitter_access_tokens"]) {
                
                if ([controller isKindOfClass:[ViewController class]]) {
//                    [[(ViewController*)controller loginView] setOAuthToken:token oauthVerifier:verifier];
                }
                if ([controller isKindOfClass:[UserViewController class]]) {
//                    [[(UserViewController*)controller loginView] setOAuthToken:token oauthVerifier:verifier];
                }
            }
            
            if ([postType isEqualToString:@"twitter_access_tokens_share"]) {
                
                NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
                NSString *token = d[@"oauth_token"];
                NSString *verifier = d[@"oauth_verifier"];
                
                if (token) {

//                    [(ThanksViewController*)controller setOAuthToken:token oauthVerifier:verifier];
                }
            }
        }
        
    }else{
        
//        return [GPPURLHandler handleURL:url
//                      sourceApplication:sourceApplication
//                             annotation:annotation];
    }
    return YES;
}

- (UIViewController*)topViewController {
   
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    NSLog(@"RootViewController:%@",rootViewController);
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
   
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    return md;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

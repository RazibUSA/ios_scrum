//
//  InternetConnection.m
//  FrameFun
//
//  Created by Najmul on 11/06/21.
//  Copyright 2011 __SmartMux__. All rights reserved.
//

#import "InternetConnection.h"
#import "Reachability.h"

@implementation InternetConnection

-(BOOL) startConnectionChecking
{
    [self showAlert];
    return [self checkInternetConnection];
}

-(void) showAlert
{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
               
    if(remoteHostStatus == NotReachable) { 
        
         UIAlertView *alertFinished = [[UIAlertView alloc] 
                                  initWithTitle:@"Warning"
                                       message:@"No Internet Connection"
                                  delegate:self cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
         [alertFinished show];
     }
}

-(BOOL) checkInternetConnection
{       
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];

    if(remoteHostStatus == NotReachable) { 
        return FALSE;
    }
    else if (remoteHostStatus == ReachableViaWWAN) { 
        
    }
    else if (remoteHostStatus == ReachableViaWiFi) { 
        
    }
    return TRUE;
}
@end

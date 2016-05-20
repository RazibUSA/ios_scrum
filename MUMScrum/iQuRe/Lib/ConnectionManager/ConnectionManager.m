//
//  ConnectionManager.m
//  ReferralHive
//
//  Created by Najmul Hasan on 10/9/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import "ConnectionManager.h"
#import "InternetConnection.h"
#import "AFNetworking.h"
#import "DataModel.h"

@implementation ConnectionManager

+ (ConnectionManager*)sharedInstance {
    static dispatch_once_t once;
    static ConnectionManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[ConnectionManager alloc] initWithDelegate:nil]; });
    return sharedInstance;
}

- (id)initWithDelegate:(id<ConnectionManagerDelegate>)myDelegate
{
    self = [super init];
    if (self) {
        
        self.delegate = myDelegate;
    }

	return self;
}

- (void)getServerDataForPost:(NSMutableDictionary*)postDict withUrl:(NSString*)urlString{
    
    InternetConnection *internetConnection = [[InternetConnection alloc] init];
	if (![internetConnection startConnectionChecking]) return;
    
    NSURL   *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Submitting Url:%@",url);
    
    if (postDict) {
        NSError *error;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postdata];
    }
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [connection start];
    [SVProgressHUD showProgress:-1 status:@"" maskType:SVProgressHUDMaskTypeGradient];
}

- (void)getAsyncServerDataForPost:(NSMutableDictionary*)postDict withUrl:(NSString*)urlString{
    
    InternetConnection *internetConnection = [[InternetConnection alloc] init];
	if (![internetConnection startConnectionChecking]) return;
    
    NSURL   *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postdata];
    
    NSLog(@"Submitting Url:%@",url);
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        if ([JSON[@"result"] count]) {
                                                            //                                                            [self actionUpdateBadges:JSON[@"result"]];
                                                            [self.delegate didCompletedFetchJSON:JSON];
                                                        }
                                                        
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"error:%@",error);
                                                    }];
    
    
    [operation start];
}

- (void)JSONRequestWithPost:(NSMutableDictionary*)postDict
                    withUrl:(NSString*)urlString
                    success:(void (^)(NSDictionary* JSON))success
                    failure:(void (^)(NSError *error, NSDictionary* JSON))failure
{
    
    InternetConnection *internetConnection = [[InternetConnection alloc] init];
	if (![internetConnection startConnectionChecking]) return;
    
    NSURL   *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Submitting Url:%@",url);
    NSLog(@"Submitting Post:%@",postDict);
    
    if (postDict) {
        NSError *error;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postdata];
    }
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        if (success) {
                                                            success((NSDictionary*)JSON);
                                                        }
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        if (failure) {
                                                            failure(error, (NSDictionary*)JSON);
                                                        }
                                                    }];
    
    
    [operation start];
}

- (void)JSONRequestWithMethod:(NSString*)method
                         body:(NSMutableDictionary*)postDict
                      withUrl:(NSString*)urlString
                      success:(void (^)(NSDictionary* JSON))success
                      failure:(void (^)(NSError *error, NSDictionary* JSON))failure
{
    
    InternetConnection *internetConnection = [[InternetConnection alloc] init];
    if (![internetConnection startConnectionChecking]) return;
    
    NSURL   *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Submitting Url:%@",url);
    NSLog(@"Submitting Post:%@",postDict);
    
    if (postDict) {
        NSError *error;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postdata];
    }
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        if (success) {
                                                            success((NSDictionary*)JSON);
                                                        }
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        if (failure) {
                                                            failure(error, (NSDictionary*)JSON);
                                                        }
                                                    }];
    
    
    [operation start];
}

-(void)getMyBadgeInfo{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fetchedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [self.fetchedData appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"Fetch Value: %@",[[NSString alloc] initWithData:self.fetchedData encoding:NSUTF8StringEncoding]);
    [self.delegate didCompletedFetchData:self.fetchedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"didFailWithError= %@",error.description);
}

@end

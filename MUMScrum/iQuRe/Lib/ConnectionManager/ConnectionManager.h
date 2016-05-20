//
//  ConnectionManager.h
//  ReferralHive
//
//  Created by Najmul Hasan on 10/9/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConnectionManager;
@protocol ConnectionManagerDelegate
@optional
-(void)didCompletedFetchData:(NSData*)fetchedData;
-(void)didCompletedFetchJSON:(NSDictionary*)fetchedData;
@end

@interface ConnectionManager : NSObject

@property (nonatomic, retain) id<ConnectionManagerDelegate> delegate;
@property (nonatomic, retain) NSMutableData *fetchedData;

+ (ConnectionManager*)sharedInstance;

- (void)getMyBadgeInfo;
- (id)initWithDelegate:(id<ConnectionManagerDelegate>)myDelegate;
- (void)getServerDataForPost:(NSDictionary*)postDict withUrl:(NSString*)urlString;
- (void)getAsyncServerDataForPost:(NSMutableDictionary*)postDict withUrl:(NSString*)urlString;
- (void)JSONRequestWithPost:(NSMutableDictionary*)postDict
                                        withUrl:(NSString*)urlString
                                        success:(void (^)(NSDictionary* JSON))success
                                        failure:(void (^)(NSError *error, NSDictionary* JSON))failure;

- (void)JSONRequestWithMethod:(NSString*)method
                         body:(NSMutableDictionary*)postDict
                      withUrl:(NSString*)urlString
                      success:(void (^)(NSDictionary* JSON))success
                      failure:(void (^)(NSError *error, NSDictionary* JSON))failure;

@end

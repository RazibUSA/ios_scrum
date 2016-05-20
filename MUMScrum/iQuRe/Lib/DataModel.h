//
//  DataModel.h
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//


// The main data model object
@interface DataModel : NSObject

+ (DataModel*)sharedInstance;

- (NSString*)myUUID;
- (NSString*)deviceToken;
- (NSString*)userId;
- (NSString*)roleId;
- (BOOL)playedOnce;

//Userdefault settings
- (void)setPlayedOnce:(BOOL)playedOnce;
- (void)setUserId:(NSString*)userId;
- (void)setRoleId:(NSString*)userId;
- (void)setDeviceToken:(NSString*)token;

//Validational methods
+ (bool)isNumber:(NSString *)string;
- (BOOL)validateEmail:(NSString *) candidate;
- (BOOL)validateUrl: (NSString *) candidate;

//Universal dates operational methods
- (int)getDaysBetween:(NSDate *)dt1 and:(NSDate *)dt2;
- (NSString*)getDaysSinceToday:(NSDate *)dt1;

//Specified operational methods
+ (UIImage *)getImageFromColor:(UIColor *)color;
- (void)makeToolBarSingleButtonWithTitle:(NSString*)title withTarget:(id)target action:(SEL)action;
- (void)makeToolBarMiddleButtonWithTitle:(NSString*)title withTarget:(id)target action:(SEL)action;

@end

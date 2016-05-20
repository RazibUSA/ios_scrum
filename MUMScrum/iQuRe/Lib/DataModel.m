//
//  DataModel.m
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "DataModel.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const DeviceTokenKey = @"DeviceToken";
static NSString* const UserId = @"UserId";
static NSString* const RoleId = @"RoleId";
static NSString* const MyUUID = @"MyUUID";
static NSString* const ONCE = @"ONCE";

@implementation DataModel

+ (void)initialize
{
	if (self == [DataModel class])
	{
		// Register default values for our settings
		[[NSUserDefaults standardUserDefaults] registerDefaults:
			@{  DeviceTokenKey: @"",
                MyUUID:@"",
                UserId:@"",
                RoleId:@"",
                ONCE:@""}];
	}
}

+ (DataModel*)sharedInstance {
    static dispatch_once_t once;
    static DataModel *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[DataModel alloc] init]; });
    return sharedInstance;
}

+(bool)isNumber:(NSString *)string {
    
    if([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

- (NSString*)myUUID
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:UserId];
    if (userId == nil || userId.length == 0) {
        userId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserId];
    }
    return userId;
}

- (NSString*)deviceToken
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

- (void)setDeviceToken:(NSString*)token
{
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)playedOnce{

    return [[NSUserDefaults standardUserDefaults] boolForKey:ONCE];
}

- (void)setPlayedOnce:(BOOL)playedOnce{

    [[NSUserDefaults standardUserDefaults] setBool:playedOnce forKey:ONCE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)userId
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:UserId];
}

- (NSString*)roleId
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:RoleId];
}

- (void)setUserId:(NSString*)userId
{
	[[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRoleId:(NSString*)roleId
{
    [[NSUserDefaults standardUserDefaults] setObject:roleId forKey:RoleId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) validateEmail: (NSString *) candidate {            //Email verification of RFC 2822
    
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateUrl: (NSString *) candidate {
//    NSString *urlRegEx =
//    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:candidate];

    NSURL *candidateURL = [NSURL URLWithString:candidate];
    if ([candidate length]) {
        if (!candidateURL.scheme.length) {
            candidateURL = [NSURL URLWithString:[@"http://" stringByAppendingString:candidate]];
        }
    }

    NSLog(@"candidateURL.scheme:  %@",candidateURL.scheme);
    NSLog(@"candidateURL.host:  %@",candidateURL.host);
    // WARNING > "test" is an URL according to RFCs, being just a path
    // so you still should check scheme and all other NSURL attributes you need
    return (candidateURL && candidateURL.scheme && candidateURL.host);
}

- (int)getDaysBetween:(NSDate *)dt1 and:(NSDate *)dt2{
   
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return (int)[components day]+1;
}

- (NSString*)getDaysSinceToday:(NSDate *)dt1{

    int days = [self getDaysBetween:dt1 and:[NSDate date]];
    return [NSString stringWithFormat:@"%d",days];
}

+ (UIImage *)getImageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)makeToolBarSingleButtonWithTitle:(NSString*)title withTarget:(id)target action:(SEL)action{
    
    UIViewController *controller = (UIViewController*)target;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:target action:nil];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    UIButton *btnSingle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSingle.frame = CGRectMake(0, 0, controller.view.frame.size.width-10, 32);
    [btnSingle addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btnSingle setBackgroundColor:[UIColor whiteColor]];
    [btnSingle setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
    [btnSingle setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    btnSingle.titleLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18.0f];
    [btnSingle setBackgroundImage:[DataModel getImageFromColor:APP_THEME_COLOR] forState:UIControlStateHighlighted];
    
    [btnSingle makeBorderCornerRadius:5.0 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    
    [items addObject:flexibleSpace];
    
    [btnSingle setTitle:title forState:UIControlStateNormal];
    [items addObject:[[UIBarButtonItem alloc] initWithCustomView:btnSingle]];
    
    [items addObject:flexibleSpace];
    [controller setToolbarItems:items];
}

- (void)makeToolBarMiddleButtonWithTitle:(NSString*)title withTarget:(id)target action:(SEL)action{
    
    UIViewController *controller = (UIViewController*)target;
    
    NSMutableArray *items = [controller.navigationController.toolbar.items mutableCopy];
    
    UIView *btnContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    btnContainerView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView *leftBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
//    leftBar.image = [UIImage imageNamed:@"divider.png"];
//    [btnContainerView addSubview:leftBar];
//    
//    UIImageView *rightBar = [[UIImageView alloc] initWithFrame:CGRectMake(btnContainerView.frame.size.width-1, 0, 1, 44)];
//    rightBar.image = [UIImage imageNamed:@"divider.png"];
//    [btnContainerView addSubview:rightBar];
    
    UIButton *btnMiddle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMiddle.frame = CGRectMake(5, 6, btnContainerView.frame.size.width-10, 32);
    [btnMiddle addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btnMiddle setBackgroundColor:[UIColor whiteColor]];
    [btnMiddle setTitleColor:APP_THEME_COLOR forState:UIControlStateNormal];
    [btnMiddle setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [btnMiddle makeBorderCornerRadius:5.0 withWidth:1.0 withColor:[UIColor lightGrayColor]];
    btnMiddle.titleLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18.0f];
    
    [btnMiddle setBackgroundImage:[DataModel getImageFromColor:APP_THEME_COLOR] forState:UIControlStateHighlighted];
    [btnMiddle setTitle:title forState:UIControlStateNormal];
    
    [btnContainerView addSubview:btnMiddle];
    
    [items insertObject:[[UIBarButtonItem alloc] initWithCustomView:btnContainerView] atIndex:2];
    
    [controller setToolbarItems:items];
}

@end

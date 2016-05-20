//
//  User.m
//  MUMScrum
//
//  Created by Najmul Hasan on 6/10/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import "User.h"
#import "NSMutableDictionary+Custom.h"
#import "Role.h"

#define   USER_PLIST        @"user.plist"

@implementation User

-(id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        _dictObject = [dict mutableCopy];
        [_dictObject resolveNullObject];
        
        [self setupMe:_dictObject];
        
        [[DataModel sharedInstance] setRoleId:self.role.role_id];
        [[DataModel sharedInstance] setUserId:self.user_id];
    }
	return self;
}

-(id)initWithFile
{
    self = [super init];
    if (self) {
        
        _dictObject = [[NSMutableDictionary alloc] initWithContentsOfFile:[DOC_FOLDER_PATH stringByAppendingPathComponent:USER_PLIST]];
        
        [self setupMe:_dictObject];
	}
	
	return self;
}

-(void)setupMe:(NSMutableDictionary*)dict{
    
    self.user_id    = [NSString stringWithFormat:@"%@",_dictObject [@"id"]];
    self.firstName  = _dictObject [@"firstName"];
    self.lastName   = _dictObject [@"lastName"];
    
    self.email      = _dictObject [@"email"];
    self.role       = [[Role alloc] initWithDictionary:_dictObject [@"role"]];
}

-(NSMutableDictionary*)getEditableDict{
    
    [self print];
    
    [_dictObject setValue:@"" forKey:@"firstName"];
    [_dictObject setValue:@"" forKey:@"lastName"];
    [_dictObject setValue:@"" forKey:@"email"];
    
    return _dictObject;
}

-(BOOL)saveUserData{
    
    [self print];
    
    NSString *userFilePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:USER_PLIST];
	return [_dictObject writeToFile:userFilePath atomically:YES];
}

-(void)print{
    
    NSLog(@"User DictObject:%@",self.dictObject);
}

@end

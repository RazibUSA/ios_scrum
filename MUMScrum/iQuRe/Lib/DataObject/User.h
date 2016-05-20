//
//  User.h
//  MUMScrum
//
//  Created by Najmul Hasan on 6/10/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Role;
@interface User : NSObject

@property(nonatomic, retain) NSString *user_id;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;

@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) Role *role;

@property(nonatomic, retain) NSMutableDictionary *dictObject;

- (id)initWithDictionary:(NSDictionary*)myDict;
- (id)initWithFile;
- (NSMutableDictionary*)getEditableDict;
- (BOOL)saveUserData;
- (void)print;

@end

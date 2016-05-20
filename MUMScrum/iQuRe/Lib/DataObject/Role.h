//
//  Role.h
//  MUMScrum
//
//  Created by Najmul Hasan on 4/10/16.
//  Copyright (c) 2016 Najmul Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Role : NSObject

@property(nonatomic, retain) NSString *role_id;
@property(nonatomic, retain) NSString *name;

@property(nonatomic, retain) NSMutableDictionary *dictObject;

- (id)initWithDictionary:(NSDictionary*)myDict;
- (void)print;

@end

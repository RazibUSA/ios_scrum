//
//  Role.m
//  MUMScrum
//
//  Created by Najmul Hasan on 4/10/16.
//  Copyright (c) 2016 Najmul Hasan. All rights reserved.
//

#import "Role.h"
#import "NSMutableDictionary+Custom.h"

@implementation Role

-(id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        _dictObject = [dict mutableCopy];
        [_dictObject resolveNullObject];
        
        [self setupMe:_dictObject];
    }
	return self;
}

-(void)setupMe:(NSMutableDictionary*)dict{
    
    self.role_id        = _dictObject [@"id"];
    self.name           = _dictObject [@"name"];
}

-(void)print{
    
    NSLog(@"Role DictObject:%@",self.dictObject);
}

@end

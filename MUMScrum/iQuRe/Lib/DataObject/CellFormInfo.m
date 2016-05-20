//
//  NodeNews.m
//  Impul-Project
//
//  Created by Huq Majharul on 11/20/12.
//  Copyright 2012 __Kryko__. All rights reserved.
//

#import "CellFormInfo.h"


@implementation CellFormInfo

@synthesize		cellName;
@synthesize		cellValue;
@synthesize		cellType;

-(id)initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
	
	if (self) {
        
		self.cellName  = [dict objectForKey:@"cellName"];
		self.cellValue = [dict objectForKey:@"cellValue"];
        self.cellKey  = [dict objectForKey:@"cellKey"];
        self.cellType  = [dict objectForKey:@"cellType"];
	}
	return self;
}

-(void)print
{
	NSLog(@"cellName : %@",self.cellName);
	NSLog(@"cellValue : %@",self.cellValue);
    NSLog(@"cellKey :%@",self.cellKey);
	NSLog(@"cellType : %@",self.cellType);
}

@end

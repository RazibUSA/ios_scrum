//
//  MyAnnotation.m
//  Project Name : Map Memo
//
//  Created by Najmul Hasan on 2012/08/03.
//  Copyright 2012 SmartMux. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize tag;

-init
{
	return self;
}

-initWithCoordinate:(CLLocationCoordinate2D)inCoord
{
	coordinate = inCoord;
	return self;
}

@end

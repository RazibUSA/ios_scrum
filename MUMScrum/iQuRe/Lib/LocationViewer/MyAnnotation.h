//
//  MyAnnotation.h
//  Project Name : Map Memo
//
//  Created by Najmul Hasan on 2012/08/03.
//  Copyright 2012 SmartMux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	int		 tag;
}

@property (nonatomic, assign) BOOL	 isMemberAnnotaion;
@property (nonatomic, assign) int	 tag;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-initWithCoordinate:(CLLocationCoordinate2D)inCoord;

@end

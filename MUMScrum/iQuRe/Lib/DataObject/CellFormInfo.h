//
//  SectionData.h
//  Impul-Project
//
//  Created by Najmul Hasan on 11/20/12.
//  Copyright 2012 __Kryko__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CellFormInfo : NSObject {
	
}

@property (nonatomic, retain) NSString  *cellName;
@property (nonatomic, retain) NSString  *cellValue;
@property (nonatomic, retain) NSString  *cellKey;
@property (nonatomic, retain) NSString  *cellType;

- (id)initWithDictionary:(NSDictionary*)dict;
- (void)print;

@end

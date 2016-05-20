//
//  KBKeyboardHandler.h
//  InstaPMS
//
//  Created by Najmul Hasan on 7/11/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta;

@end

@interface KBKeyboardHandler : NSObject

- (id)init;

// Put 'weak' instead of 'assign' if you use ARC
@property(nonatomic, assign) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end

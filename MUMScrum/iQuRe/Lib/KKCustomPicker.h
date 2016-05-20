//
//  KKCustomPicker.h
//
//
//  Created by Najmul Hasan on 4/08/2014.
//  Copyright 2014 KrykoSoft
//
//


#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <UIKit/UIKit.h>


@class KKCustomPicker;

@protocol KKCustomPickerDelegate <UIPickerViewDelegate>

- (void)customPicker:(KKCustomPicker *)picker didSelectRow:(NSString *)item;

@end


@interface KKCustomPicker : UIPickerView

@property (nonatomic, retain) NSArray *customItems;
@property (nonatomic, weak_delegate) id<KKCustomPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDataSourceFrame:(NSArray*)items;

@end

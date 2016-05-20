//
//  KKCustomPicker.h
//
//
//  Created by Najmul Hasan on 4/08/2014.
//  Copyright 2014 KrykoSoft
//
//

#import "KKCustomPicker.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface KKCustomPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation KKCustomPicker

//doesn't use _ prefix to avoid name clash
@synthesize delegate;

- (void)setup
{
    [super setDataSource:self];
    [super setDelegate:self];
}

- (id)initWithFrame:(CGRect)frame withDataSourceFrame:(NSArray*)items
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
        _customItems = items;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (void)setDataSource:(__unused id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return [_customItems count];
}

//- (CGFloat)pickerView:(__unused UIPickerView *)pickerView rowHeightForComponent:(__unused NSInteger)component{
//
//    return 80.0f;
//}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(3, -5, 245, 87)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:17];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    NSString *item = _customItems[row];

    ((UILabel *)[view viewWithTag:1]).text = item;//[NSString stringWithFormat:@"%d. %@",row+1, item];
    
    return view;
}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    NSString *item = _customItems[row];
    [delegate customPicker:self didSelectRow:item];
}

@end

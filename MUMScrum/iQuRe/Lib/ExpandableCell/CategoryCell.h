
#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell

@property (nonatomic) BOOL isOpen;
@property (nonatomic,retain) IBOutlet UIImageView *arrowImageView;
@property (nonatomic,retain) IBOutlet UIImageView *thumbImageView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

- (void)changeArrowWithUp:(BOOL)up;

@end

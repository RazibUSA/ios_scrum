
#import "CategoryCell.h"

@implementation CategoryCell
@synthesize arrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    self.isOpen = up;
    self.arrowImageView.image = (up)?[UIImage imageNamed:@"UpAccessory.png"]:[UIImage imageNamed:@"DownAccessory.png"];
}

@end

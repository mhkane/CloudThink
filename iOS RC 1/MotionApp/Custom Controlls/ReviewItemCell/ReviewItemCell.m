//
//  ReviewCell.m

#import "ReviewItemCell.h"

@implementation ReviewItemCell

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

- (void)CellText:(NSString *)text CellTextForValue:(NSString *)value
{
    listName.text = text;
    listValue.text = value;
    listImgView.hidden = YES;
    listValue.hidden = NO;
}


- (void)CellText:(NSString *)text CellImage:(UIImage *)img
{
    listName.text = text;
    listImgView.image = img;
    listValue.hidden = YES;
    listImgView.hidden = NO;
}


@end

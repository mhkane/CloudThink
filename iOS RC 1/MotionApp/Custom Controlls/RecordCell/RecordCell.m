//
//  ReviewCell.m

#import "RecordCell.h"

@implementation RecordCell

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
    _listName.text = text;
    _listValue.text = value;
    _listValue.hidden = NO;
    _listImgView.hidden = YES;
}

- (void)CellText:(NSString *)text CellImage:(UIImage *)img
{
    _listName.text = text;
    _listImgView.image = img;
    _listValue.hidden = YES;
    _listImgView.hidden = NO;
}

//- (void)CellText:(NSString *)text CellTextForValue:(NSString *)value CellImage:(UIImage *)img
//{
//    listName.text = text;
//    listImgView.image = img;
//    listValue.hidden = NO;
//
//}

@end

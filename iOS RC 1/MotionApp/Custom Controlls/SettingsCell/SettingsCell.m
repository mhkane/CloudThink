//
//  SettingsCell.m

#import "SettingsCell.h"

@implementation SettingsCell

@synthesize listSwitch;

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
    listSwitch.hidden = YES;
    listValue.hidden = NO;
    m_ivRightArrow.hidden = NO;
}


- (void)CellText:(NSString *)text CellSwitchValue:(BOOL)value
{
    listName.text = text;
    [listSwitch setOn:value];
    listValue.hidden = YES;
    listSwitch.hidden = NO;
    m_ivRightArrow.hidden = YES;
}


@end

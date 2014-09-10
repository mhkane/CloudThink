//
//  SettingsCell.h

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell
{
    IBOutlet UILabel * listName;
    IBOutlet UISwitch * listSwitch;
    IBOutlet UILabel * listValue;
    __weak IBOutlet UIImageView *m_ivRightArrow;
}

@property(nonatomic, strong) IBOutlet UISwitch * listSwitch;


- (void)CellText:(NSString *)text CellTextForValue:(NSString *)value;
- (void)CellText:(NSString *)text CellSwitchValue:(BOOL)value;

@end

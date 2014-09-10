//
//  SettingsValueCell.h

#import <UIKit/UIKit.h>

@interface SettingsValueCell : UITableViewCell<UITextFieldDelegate>
{
    IBOutlet UITextField * settingsValueTextField;
}

@property(nonatomic, strong) IBOutlet UITextField * settingsValueTextField;


@end

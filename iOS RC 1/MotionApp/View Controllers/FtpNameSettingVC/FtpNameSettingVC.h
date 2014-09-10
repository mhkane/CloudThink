//
//  FtpNameSettingVC.h

#import <UIKit/UIKit.h>

@interface FtpNameSettingVC : UIViewController<UITextFieldDelegate>
{
    NSString * value;
    IBOutlet UITableView * tablView;
}

@property(nonatomic, strong) NSString * value;

-(IBAction)settingBtn:(id)sender;

@end


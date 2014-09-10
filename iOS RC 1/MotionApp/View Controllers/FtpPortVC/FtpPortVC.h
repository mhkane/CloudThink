//
//  FtpPortVC.h
//  MotionApp

#import <UIKit/UIKit.h>

@interface FtpPortVC : UIViewController<UITextFieldDelegate>
{
    NSString * value;
    IBOutlet UITableView * tablView;
}

@property(nonatomic, strong) NSString * value;

-(IBAction)settingBtn:(id)sender;

@end

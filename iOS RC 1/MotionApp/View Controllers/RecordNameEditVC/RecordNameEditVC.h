//
//  RecordNameEditVC.h

#import <UIKit/UIKit.h>

@interface RecordNameEditVC : UIViewController<UITextFieldDelegate>
{
    NSString * value;
    IBOutlet UITableView * tablView;
    int m_nRecordIndex;
}

@property(nonatomic, strong) NSString * value;

-(IBAction)settingBtn:(id)sender;
- (void)setRecordIndex:(int)nIndex;

@end

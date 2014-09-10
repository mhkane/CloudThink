//
//  ReviewVC.h

#import <UIKit/UIKit.h>

@interface ReviewVC : UIViewController
{
    IBOutlet UITableView * reviewTableView;
    IBOutlet UIButton * editBtn;
}

- (IBAction)editBtn:(id)sender;

@end

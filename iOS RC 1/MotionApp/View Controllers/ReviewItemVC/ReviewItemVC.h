//
//  ReviewItemVC.h

#import <UIKit/UIKit.h>
#import "RecordObject.h"
#import "GCDAsyncSocket.h"

@interface ReviewItemVC : UIViewController
{
    IBOutlet UITableView * tableview;
	GCDAsyncSocket *asyncSocket;
    int m_nIndexRecord;
}

- (IBAction)backbtn:(id)sender;
- (IBAction)sendEmailBtn:(id)sender;
- (void)setRecordIndex:(int)nIndex;

@end

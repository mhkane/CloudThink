//
//  RecordVC.h

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "RecordObject.h"
#import "CloudThinkParserClass.h"
#import "GCDAsyncSocket.h"

extern BOOL checkinVChasPopped;

@interface RecordVC : UIViewController<CLLocationManagerDelegate, UpdateViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CLLocationManager * locationManger;
    CMMotionManager * motionManager;
    IBOutlet UITableView * recordTableView;
    IBOutlet UIButton * startBtn;
    IBOutlet UIButton * pauseBtn;
//    NSMutableArray * recordsArray;
	GCDAsyncSocket *asyncSocket;
}

//@property(nonatomic, strong) NSMutableArray * recordsArray;
@property(nonatomic, strong) CLLocationManager * locationManger;
@property(nonatomic, strong) CMMotionManager * motionManager;
@property(nonatomic, strong) CMMotionActivityManager * motionActivity;

- (IBAction)startBtn:(id)sender;
- (IBAction)pauseBtn:(id)sender;

@end

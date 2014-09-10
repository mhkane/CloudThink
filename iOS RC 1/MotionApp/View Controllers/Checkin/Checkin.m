//
//  SettingsVC.m

#import "Checkin.h"

BOOL checkinVChasPopped;

@interface Checkin ()
{
}

@property (weak, nonatomic) IBOutlet UIButton *m_btnwalking;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBus;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRunning;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAriplane;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCycling;
@property (weak, nonatomic) IBOutlet UIButton *m_btnTrain;
@property (weak, nonatomic) IBOutlet UIButton *m_btnDriving;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBoat;
@property (weak, nonatomic) IBOutlet UIButton *m_btnStationary;

- (IBAction)onClickBtn:(UIButton*)sender;
- (IBAction)onClickBack:(id)sender;

@end

@implementation Checkin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickBtn:(UIButton*)sender {
    if (sender == _m_btnwalking)
    {
        
    }
    else if (sender == _m_btnBus)
    {
        
    }
    else if (sender == _m_btnRunning)
    {
        
    }
    else if (sender == _m_btnAriplane)
    {
        
    }
    else if (sender == _m_btnCycling)
    {
        
    }
    else if (sender == _m_btnTrain)
    {
        
    }
    else if (sender == _m_btnDriving)
    {
        
    }
    else if (sender == _m_btnBoat)
    {
        
    }
    else if (sender == _m_btnStationary)
    {
        
    }
    int nIndex = (int)sender.tag;
    m_gIndexCheckin = [m_gAryCheckin count] > nIndex ? nIndex : -1;
    NSLog(@"%d, %@", m_gIndexCheckin, [m_gAryCheckin description]);
    [self.navigationController popViewControllerAnimated:YES];
    checkinVChasPopped = FALSE;
    //[controller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    checkinVChasPopped = FALSE;
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end

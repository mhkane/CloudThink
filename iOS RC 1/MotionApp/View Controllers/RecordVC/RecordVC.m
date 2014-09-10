//
//  ViewController.m

#import "RecordVC.h"
#import "RecordCell.h"
#import "GpsObject.h"
#import "CompassObject.h"
#import "AccelObject.h"
#import "GyroScopeObject.h"
#import "RecordVC.h"
#import "DataBaseManager.h"
#import "ReviewVC.h"
#import "HttpWorker.h"
#import "MResources.h"
#import "ContextObject.h"
#import "CloudObject.h"
#import "Checkin.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


static int record_Id;

@interface RecordVC ()<UIActionSheetDelegate>
{
    NSDateFormatter * formatter;
    NSMutableArray * keysArray;
    NSMutableDictionary * m_dic;
    NSMutableArray * gpsArray;
    NSMutableArray * accelArray;
    NSMutableArray * gyroScope;
    NSMutableArray * compassArray;
    NSMutableArray * contextArray;
    NSMutableArray * cloudArray;
    NSString * startTime;
    NSString * currentTime;
    int counter;
    NSTimer * timer;
    NSTimer * timerForCloudThink;
    int flagForStartStopBtn;
    int flafForPauseResumeBtn;
    int isGyroOn;
    int isComOn;
    int isGpsOn;
    int isAccOn;
    NSUserDefaults * userDefaults;
    NSString * gpsQuality;
    NSString * motionContext;
    NSString * cloudThinkImage;
    NSString * cloudThinkConnectedStatus;
    UIBackgroundTaskIdentifier counterTask;
    
    int m_nTimeForTCP;
    NSDate* m_dateForTCP;
    int m_nTimeForCheckin;
    BOOL m_bShowedCheckinView;
    BOOL checkinVChasPopped;
}

@end

@implementation RecordVC

@synthesize locationManger;
@synthesize motionManager;
//@synthesize recordsArray;
@synthesize motionActivity;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    cloudThinkConnectedStatus = @"";
    [userDefaults setFloat:1.0 forKey:kUSER_DEFAULT_ACCVALUE];
    [userDefaults setFloat:1.0 forKey:kUSER_DEFAULT_GYROVALUE];
    gpsQuality = @"";
    motionContext = @"";
    cloudThinkImage = @"circle_red.png";
    record_Id = 0;
    userDefaults = [NSUserDefaults standardUserDefaults];
    isGyroOn = 1;
    isComOn = 1;
    isGpsOn = 1;
    isAccOn =1;
    [userDefaults setInteger:isAccOn forKey:kUSER_DEFAULT_ISACCON];
    [userDefaults setInteger:isGyroOn forKey:kUSER_DEFAULT_ISGYROON];
    [userDefaults setInteger:isComOn forKey:kUSER_DEFAULT_ISCOMON];
    [userDefaults setInteger:isGpsOn forKey:kUSER_DEFAULT_ISGPSON];
    
    recordsArray = [[NSMutableArray alloc] init];
    flafForPauseResumeBtn = 0;
    pauseBtn.enabled = NO;
    counter = 0;
    flagForStartStopBtn = 0;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSSS"];
    
    keysArray = [[NSMutableArray alloc]initWithObjects:@"Run", @"Last Readings", @"Check-in", nil];
    NSMutableArray * runsArray = [[NSMutableArray alloc]initWithObjects:@"Start Time", @"Duration", nil];
    NSMutableArray * lastReadingsArray = [[NSMutableArray alloc]initWithObjects:@"GPS Qual.", @"Position", @"Accel.", @"Heading", @"Rotation", @"Context", @"CloudThink", nil];
    NSMutableArray * checkinArray = [[NSMutableArray alloc]initWithObjects:@"Check-in", nil];
    
    m_dic = [[NSMutableDictionary alloc]init];
    [m_dic setObject:runsArray forKey:@"Run"];
    [m_dic setObject:lastReadingsArray forKey:@"Last Readings"];
    [m_dic setObject:checkinArray forKey:@"Check-in"];
    
    gpsArray = [[NSMutableArray alloc]init];
    accelArray = [[NSMutableArray alloc]init];
    gyroScope = [[NSMutableArray alloc]init];
    compassArray = [[NSMutableArray alloc]init];
    contextArray = [[NSMutableArray alloc]init];
    cloudArray = [[NSMutableArray alloc]init];

    self.locationManger = [[CLLocationManager alloc]init];
    self.locationManger.delegate = self;
    [self.locationManger requestAlwaysAuthorization];
    [self.locationManger startMonitoringSignificantLocationChanges];
    [self.locationManger startUpdatingLocation];

    self.motionManager = [[CMMotionManager alloc] init];
    self.motionActivity = [[CMMotionActivityManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = [[userDefaults objectForKey:kUSER_DEFAULT_ACCVALUE] floatValue];
    self.motionManager.gyroUpdateInterval = [[userDefaults objectForKey:kUSER_DEFAULT_GYROVALUE] floatValue];

    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    m_nTimeForTCP = 0;
    m_dateForTCP = [NSDate date];
    m_nTimeForCheckin = 0;
    m_bShowedCheckinView = FALSE;
    
    checkinVChasPopped = FALSE;
}

- (void)viewWillAppear:(BOOL)animated
{
    isGpsOn = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISGPSON];
    isComOn = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISCOMON];
    isGyroOn = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISGYROON];
    isAccOn = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISACCON];
    
    self.motionManager.accelerometerUpdateInterval = 1 / [[userDefaults objectForKey:kUSER_DEFAULT_ACCVALUE] floatValue];
    self.motionManager.gyroUpdateInterval = 1 / [[userDefaults objectForKey:kUSER_DEFAULT_GYROVALUE] floatValue];
    m_bShowedCheckinView = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendTCP:(id)sender {
    NSString* strTCPAddress = [userDefaults objectForKey:kUSER_DEFAULT_TCPSEVERADDRESS];
    NSString* strTCPPort = [userDefaults objectForKey:kUSER_DEFAULT_TCPPORT];
    if (!strTCPAddress || !strTCPPort)
    {
        return;
    }

    uint16_t port = [strTCPPort intValue];
    NSError *error = nil;
    if ([asyncSocket connectToHost:strTCPAddress onPort:port error:&error])
    {
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

//Start Button Action
- (IBAction)startBtn:(id)sender
{
    if (flagForStartStopBtn == 0)
    {
        [startBtn setTitle:@"Stop" forState:UIControlStateNormal];
        pauseBtn.enabled = YES;
        flagForStartStopBtn = 1;
        NSDate * date = [NSDate date];
        startTime = [formatter stringFromDate:date];

        if (isComOn == 1)
        {
            [self.locationManger startUpdatingHeading];
        }
        
        if (isGpsOn == 1)
        {
            [self.locationManger startUpdatingLocation];
        }
        
        if (isAccOn == 1)
        {
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                     withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                         [self outputAccelertionData:accelerometerData.acceleration];
                                                         if(error){
                                                             
                                                             NSLog(@"%@", error);
                                                         }
                                                     }];
        }
        
        if (isGyroOn == 1)
        {
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error) {
                                                [self outputRotationData:gyroData.rotationRate];
                                            }];
        }
        
        //Motion State
        if ([CMMotionActivityManager isActivityAvailable])
        {
            [self.motionActivity startActivityUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                 withHandler:
             ^(CMMotionActivity *activity) {
                 
                 [self outputActivityData:activity];
             }];
            
        }
        else
        {
            motionContext = @"Not Available in Device!";
        }
        
        //CloudThink
        
        timerForCloudThink = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(callCloudThinkService) userInfo:Nil repeats:YES];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTimerValue:) userInfo:Nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:timer forMode: NSDefaultRunLoopMode];
        m_nTimeForTCP = 0;
        m_nTimeForCheckin = 0;
        m_bShowedCheckinView = FALSE;
    }
    else
    {
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"Save Log" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Discard Log" otherButtonTitles:@"Save Log", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[self.view window]];
//        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
//        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
        [startBtn setTitle:@"Start" forState:UIControlStateNormal];
        [pauseBtn setTitle:@"Pause" forState:UIControlStateNormal];
        flafForPauseResumeBtn = 0;
        pauseBtn.enabled = NO;
        flagForStartStopBtn = 0;
        [timerForCloudThink invalidate];
        [timer invalidate];
        [self.locationManger stopUpdatingHeading];
        [self.locationManger stopUpdatingLocation];
        [self.motionManager stopGyroUpdates];
        [self.motionManager stopAccelerometerUpdates];
        if ([CMMotionActivityManager isActivityAvailable])
        {
            [self.motionActivity stopActivityUpdates];
            motionContext = @"";
        }
        else
        {
            motionContext = @"";
        }
        [[UIApplication sharedApplication] endBackgroundTask:counterTask];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        //destructive and new start
        [gpsArray removeAllObjects];
        [accelArray removeAllObjects];
        [gyroScope removeAllObjects];
        [compassArray removeAllObjects];
        [contextArray removeAllObjects];
        [cloudArray removeAllObjects];
        startTime = @"";
        currentTime = @"";
        flafForPauseResumeBtn = 0;
        pauseBtn.enabled = NO;
        counter = 0;
        flagForStartStopBtn = 0;
        [recordTableView reloadData];
        m_bShowedCheckinView = FALSE;
    }
    else
    {
        //Save
        RecordObject * recordObject = [[RecordObject alloc]init];
        recordObject.record_name = @"Unnamed Record";
        recordObject.record_time = [formatter dateFromString:startTime];
        recordObject.record_duration = counter;
        recordObject.gpsObject = [NSMutableArray arrayWithArray:gpsArray];
        recordObject.gyroScopeObject = [NSMutableArray arrayWithArray:gyroScope];
        recordObject.accelObject = [NSMutableArray arrayWithArray:accelArray];
        recordObject.compassObject = [NSMutableArray arrayWithArray:compassArray];
        recordObject.contextArray = [NSMutableArray arrayWithArray:contextArray];
        recordObject.cloudArray = [NSMutableArray arrayWithArray:cloudArray];
        recordObject.isAccOn = isAccOn;
        recordObject.isComOn = isComOn;
        recordObject.isGyroOn = isGyroOn;
        recordObject.isGpsOn = isGpsOn;
        [recordsArray addObject:recordObject];
        
//        UINavigationController * recordNav = (UINavigationController *) [self.tabBarController.viewControllers objectAtIndex:1];
//        ReviewVC * reviewVC = (ReviewVC *)[recordNav.viewControllers objectAtIndex:0];
//        reviewVC.recordsArray = recordsArray;
        //        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        //        [userDefaults setObject:self.recordsArray forKey:@"recordsArray"];
        //        [userDefaults synchronize];
        
        [gpsArray removeAllObjects];
        [accelArray removeAllObjects];
        [gyroScope removeAllObjects];
        [compassArray removeAllObjects];
        [contextArray removeAllObjects];
        [cloudArray removeAllObjects];
        startTime = @"";
        currentTime = @"";
        flafForPauseResumeBtn = 0;
        pauseBtn.enabled = NO;
        counter = 0;
        flagForStartStopBtn = 0;
        gpsQuality = @"";
        [recordTableView reloadData];
        // TODO: Save persistent here
    }
}

- (void)saveRecord
{
    dispatch_async(kBgQueue, ^{
        NSMutableArray * newRecordArray = [[[DataBaseManager alloc]init] selectRecords];
        RecordObject * lastRecord = [newRecordArray lastObject];
        if (lastRecord)
            [self performSelectorOnMainThread:@selector(saveRecordSensors:) withObject:[NSNumber numberWithInt:lastRecord.record_id] waitUntilDone:YES];
    });
}

- (void)saveRecordSensors:(NSNumber *)record_id
{
    DataBaseManager * dataBaseManager = [[DataBaseManager alloc]init];
    NSLog(@"id: %d",[record_id intValue]);
    
    dispatch_async(kBgQueue, ^{
        for (GpsObject * gps in gpsArray)
        {
            [dataBaseManager insertGps:gps WithRecordId:[record_id intValue]];
        }
        
        for (GyroScopeObject * gyro in gyroScope)
        {
            [dataBaseManager insertGyro:gyro WithRecordId:[record_id intValue]];
        }
        
        for (CompassObject * compass in compassArray)
        {
            [dataBaseManager insertCompass:compass WithRecordId:[record_id intValue]];
        }
        
        for (AccelObject * accel in accelArray)
        {
            [dataBaseManager insertAccel:accel WithRecordId:[record_id intValue]];
        }
        [self performSelectorOnMainThread:@selector(updateUIAfterSavingData) withObject:Nil waitUntilDone:YES];
        
    });
}


- (void)updateUIAfterSavingData
{
    [gpsArray removeAllObjects];
    [accelArray removeAllObjects];
    [gyroScope removeAllObjects];
    [compassArray removeAllObjects];
    [recordsArray removeAllObjects];
    [contextArray removeAllObjects];
    [cloudArray removeAllObjects];
    startTime = @"";
    currentTime = @"";
    flafForPauseResumeBtn = 0;
    pauseBtn.enabled = NO;
    counter = 0;
    flagForStartStopBtn = 0;
    [recordTableView reloadData];
}

- (IBAction)pauseBtn:(id)sender
{

    if (flafForPauseResumeBtn == 0)
    {
        [pauseBtn setTitle:@"Resume" forState:UIControlStateNormal];
        flafForPauseResumeBtn = 1;
        [timer invalidate];
    }
    else
    {
        [pauseBtn setTitle:@"Pause" forState:UIControlStateNormal];
        flafForPauseResumeBtn = 0;
        NSDate * date = [NSDate date];
        startTime = [formatter stringFromDate:date];
        
        if (isComOn == 1)
        {
            [self.locationManger startUpdatingHeading];
        }
        
        if (isGpsOn == 1)
        {
            [self.locationManger startUpdatingLocation];
        }
        
        if (isAccOn == 1)
        {
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                     withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                         [self outputAccelertionData:accelerometerData.acceleration];
                                                         if(error){
                                                             
                                                             NSLog(@"%@", error);
                                                         }
                                                     }];
        }
        
        if (isGyroOn == 1)
        {
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error) {
                                                [self outputRotationData:gyroData.rotationRate];
                                            }];
        }
        
        [self runTimerInBackground];
       
    }
}

- (void)runTimerInBackground
{
    counterTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        //...
    }];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setTimerValue:) userInfo:Nil repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode: NSDefaultRunLoopMode];
}

- (void)setTimerValue:(NSTimer *)timer
{
    Checkin* vc = [[Checkin alloc] initWithNibName:@"Checkin" bundle:nil];
    
    counter = counter + 1;
    //NSLog(@"running: %d",counter);
    currentTime = [self timeFormatted:counter];
    [recordTableView reloadData];
    m_nTimeForTCP++;
    if (m_nTimeForTCP == 60)
    {
        if ([asyncSocket isConnected])
        {
            [self sendDataViaTCP];
        }
        else {
            [self sendTCP:nil];
        }
        
        m_nTimeForTCP = 0;
        m_dateForTCP = [NSDate date];
    }
    
    if (!m_bShowedCheckinView) // Show the first run
    {
        m_bShowedCheckinView = TRUE;
        // Checkin
        if (checkinVChasPopped == FALSE) {
            checkinVChasPopped = TRUE;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    m_nTimeForCheckin++;
    if (m_nTimeForCheckin == 300) // Go every 5 minutes (300 seconds)
    {
        NSLog(@"Checking in: %d",m_nTimeForCheckin);
        m_nTimeForCheckin = 0;
        // Checkin
        //if (checkinVChasPopped == FALSE) { // Ignore the check here, because the computer will only pop it once regardless
        // The only issue here is that if the user ignores the prompts for too long, a queue of screens can and will pile up
        // To be fixed... later... by someone else, hopefully
            checkinVChasPopped = TRUE;
            [self.navigationController pushViewController:vc animated:YES];
        //}
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    NSDate * date = [NSDate date];
    
    //Heading
    CompassObject * compassObject = [[CompassObject alloc]init];
    compassObject.timeStamp = [formatter stringFromDate:date];
    compassObject.magHeading = [NSString stringWithFormat:@"%.4f", newHeading.magneticHeading];
    compassObject.trueHeading = [NSString stringWithFormat:@"%.4f", newHeading.trueHeading];
    NSDictionary * dic = [NSDictionary dictionaryWithObject:compassObject forKey:[formatter stringFromDate:[NSDate date]]];
    [compassArray addObject:dic];
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation * lastLocation = [locations lastObject];
    
    //GPS Desired Accuracy "GPS QUality"
    gpsQuality = [NSString stringWithFormat:@"%f",lastLocation.horizontalAccuracy];
    //NSLog(@"gpsQuality: %@",gpsQuality);
    
    //Postion
    GpsObject * gpsObject = [[GpsObject alloc]init];
    NSDate * date = [NSDate date];
    gpsObject.timeStamp = [formatter stringFromDate:date];
    gpsObject.log = [NSString stringWithFormat:@"%.6f", lastLocation.coordinate.longitude];
    gpsObject.lat = [NSString stringWithFormat:@"%.6f", lastLocation.coordinate.latitude];
    gpsObject.height = [NSString stringWithFormat:@"%.6f",lastLocation.altitude];
    NSDictionary * dic = [NSDictionary dictionaryWithObject:gpsObject forKey:[formatter stringFromDate:[NSDate date]]];
    [gpsArray addObject:dic];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //Accel.
    AccelObject * accelObject = [[AccelObject alloc]init];
    NSDate * date = [NSDate date];
    accelObject.timeStamp = [formatter stringFromDate:date];
    accelObject.x = [NSString stringWithFormat:@" %.6fg",acceleration.x];
    accelObject.y = [NSString stringWithFormat:@" %.6fg",acceleration.y];
    accelObject.z = [NSString stringWithFormat:@" %.6fg",acceleration.z];
    //NSLog(@"accel_x: %@",accelObject.x);
    NSDictionary * dic = [NSDictionary dictionaryWithObject:accelObject forKey:[formatter stringFromDate:[NSDate date]]];
    [accelArray addObject:dic];
}


-(void)outputRotationData:(CMRotationRate)rotation
{
    //Rotation
    GyroScopeObject * gyroScopeObject = [[GyroScopeObject alloc]init];
    NSDate * date = [NSDate date];
    gyroScopeObject.timeStamp = [formatter stringFromDate:date];
    gyroScopeObject.x = [NSString stringWithFormat:@" %.6f",rotation.x];
    gyroScopeObject.y = [NSString stringWithFormat:@" %.6f",rotation.y];
    gyroScopeObject.z = [NSString stringWithFormat:@" %.6f",rotation.z];
    NSDictionary * dic = [NSDictionary dictionaryWithObject:gyroScopeObject forKey:[formatter stringFromDate:[NSDate date]]];
    [gyroScope addObject:dic];
}

- (void)outputActivityData:(CMMotionActivity *)activity
{
    //NSString* strContext = motionContext;
    if ([activity walking])
    {
        motionContext = @"Walking";
    }
    else if ([activity running])
    {
        motionContext = @"Running";
    }
    else if ([activity automotive])
    {
        motionContext = @"Automotive";
    }
    else if ([activity stationary])
    {
        motionContext = @"Stationary";
    }
    else if ([activity unknown])
    {
        motionContext = @"Unknown";
    }
    /*
    if (![strContext isEqualToString:motionContext])
    {
        if (!m_bShowedCheckinView)
        {
            m_bShowedCheckinView = TRUE;
            // Checkin
            Checkin* vc = [[Checkin alloc] initWithNibName:@"Checkin" bundle:nil];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    */
    
    ContextObject * contextObject = [[ContextObject alloc]init];
    NSDate * currentDate = [NSDate date];
    contextObject.timeStamp = [formatter stringFromDate:currentDate];
    contextObject.contextValue = motionContext;
    NSDictionary * dic = [NSDictionary dictionaryWithObject:contextObject forKey:[formatter stringFromDate:[NSDate date]]];
    [contextArray addObject:dic];
    NSLog(@"motionContext: %@",motionContext);
}

- (void)callCloudThinkService
{
    NSString * vin = [userDefaults valueForKey:kUSER_DEFAULT_VINVALUE];
    //vin=[@"VIN" stringByAppendingString:vin];
    NSString * api_url = [NSString stringWithFormat:@"https://api.cloud-think.com/data/%@",vin];
    HttpWorker * httpWorker = [[HttpWorker alloc]init];
    [httpWorker requestNetwork:api_url];
    [httpWorker setDelegate:[[MResources getResources] getCloudThinkParserClass]];
    [[[MResources getResources] getCloudThinkParserClass]setDelegate:self];
}

- (void)updateView:(BOOL)isConnected
{
    if (isConnected)
    {
        cloudThinkImage = @"circle.png";
        cloudThinkConnectedStatus = @"Connected Recently";
    }
    else
    {
        cloudThinkImage = @"circle_red.png";
        cloudThinkConnectedStatus = @"Not Connected";
    }
    NSString* strCheckIn = @"Unknown";
    if (m_gIndexCheckin != -1)
    {
        strCheckIn = [m_gAryCheckin objectAtIndex:m_gIndexCheckin];
    }
    
    CloudObject * cloudObject = [[CloudObject alloc]init];
    NSDate * currentDate = [NSDate date];
    cloudObject.timeStamp = [formatter stringFromDate:currentDate];
    cloudObject.cloudValue = cloudThinkConnectedStatus;
    cloudObject.cloudThinkImage = cloudThinkImage;
    cloudObject.Checkin = strCheckIn;
    NSDictionary * dic = [NSDictionary dictionaryWithObject:cloudObject forKey:[formatter stringFromDate:[NSDate date]]];
    [cloudArray addObject:dic];
//    [recordTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * header = [keysArray objectAtIndex:section];
    NSMutableArray * temp = [m_dic objectForKey:header];
    return temp.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell * cell = (RecordCell *) [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString * header = [keysArray objectAtIndex:indexPath.section];
    NSMutableArray * temp = [m_dic objectForKey:header];
    NSString * text = [temp objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == temp.count-1)
            {
                //Timer Value
                [cell CellText:text CellTextForValue:currentTime ? currentTime : @""];
            }
            else if (indexPath.row == temp.count-2)
            {
                //Start Time
                [cell CellText:text CellTextForValue:startTime ? startTime : @""];
            }
            break;
        case 1:
            if (indexPath.row == temp.count-1)
            {
                //CloudThink
                
                [cell CellText:text CellImage:[UIImage imageNamed:cloudThinkImage]];
            }
            else if(indexPath.row == temp.count-2)
            {
                //Context
                ContextObject * contextObject = [[contextArray lastObject] allObjects] && [[[contextArray lastObject] allObjects] count] > 0 ? [[[contextArray lastObject] allObjects] objectAtIndex:0] : nil;
                if (!contextObject.contextValue)
                {
                    [cell CellText:text CellTextForValue:@"Initializing"];
                }
                else
                {
                    [cell CellText:text CellTextForValue:contextObject.contextValue];
                }
            }
            else if (indexPath.row == temp.count-3)
            {
                //Rotation
                GyroScopeObject * gyroScopeObject = [[gyroScope lastObject] allObjects] && [[[gyroScope lastObject] allObjects] count] > 0 ? [[[gyroScope lastObject] allObjects] objectAtIndex:0] : nil;
                if (gyroScopeObject)
                {
                    [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@, %@, %@",gyroScopeObject.x, gyroScopeObject.y,gyroScopeObject.z]];
                }
                else
                {
                    [cell CellText:text CellTextForValue:@"N/A"];
                }
            }
            else if (indexPath.row == temp.count-4)
            {
                //Heading
                CompassObject * compassObject = [[compassArray lastObject] allObjects] && [[[compassArray lastObject] allObjects] count] > 0 ? [[[compassArray lastObject] allObjects] objectAtIndex:0] : nil;
                if (compassObject)
                {
                    [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@, %@",compassObject.magHeading, compassObject.trueHeading]];
                }
                else
                {
                    [cell CellText:text CellTextForValue:@"N/A"];
                }
            }
            else if (indexPath.row == temp.count-5)
            {
                //Accel.
                AccelObject * accelObject = [[accelArray lastObject] allObjects] && [[[accelArray lastObject] allObjects] count] > 0 ? [[[accelArray lastObject] allObjects] objectAtIndex:0] : nil;
                if (accelObject)
                {
                    [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@, %@, %@",accelObject.x, accelObject.y,accelObject.z]];
                }
                else
                {
                    [cell CellText:text CellTextForValue:@"N/A"];
                }
                
            }
            else if (indexPath.row == temp.count-6)
            {
                //Postion
                GpsObject * gpsObject = [[gpsArray lastObject] allObjects] && [[[gpsArray lastObject] allObjects] count] > 0 ? [[[gpsArray lastObject] allObjects] objectAtIndex:0] : nil;
                if (gpsObject)
                {
                    [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@, %@, %@",gpsObject.log,gpsObject.lat, gpsObject.height]];
                }
                else
                {
                    [cell CellText:text CellTextForValue:@""];
                }
                
            }
            else if (indexPath.row == temp.count-7)
            {
                //GPS Qual.
                [cell CellText:text CellTextForValue:gpsQuality];
            }
            break;
        case 2:
            if (indexPath.row == 0){
                [cell CellText:text CellTextForValue:@""];
            }
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return keysArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * header = [keysArray objectAtIndex:section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        m_nTimeForCheckin = 0; // Reset checkin counter
        // Checkin
        Checkin* vc = [[Checkin alloc] initWithNibName:@"Checkin" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int secnd = totalSeconds % 60;
    int minte = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minte, secnd];
}

- (void)sendDataViaTCP
{
    NSMutableString* strFileContent = [NSMutableString stringWithString:@"START,IOS"];
    [strFileContent appendFormat:@"\r\n%@,%@ ",@"USER", [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] ? [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] : @""];
    
    NSDate *DateBefore5Second = [[NSDate date] dateByAddingTimeInterval:-5]; // Go back 5 seconds...
    NSDate *DateBefore30Second = [[NSDate date] dateByAddingTimeInterval:-31]; // Go back 31 seconds...
    
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (!evaluatedObject && [evaluatedObject allKeys].count == 0)
            return FALSE;
        NSDate* date = [formatter dateFromString:[[evaluatedObject allKeys] objectAtIndex:0]];
        if (date > DateBefore5Second) {
          return [date compare:DateBefore5Second] == NSOrderedDescending;
        }
        else {
            return FALSE;
        }
    }];

    NSPredicate* predicatelong = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (!evaluatedObject && [evaluatedObject allKeys].count == 0)
            return FALSE;
        NSDate* date = [formatter dateFromString:[[evaluatedObject allKeys] objectAtIndex:0]];
        if (date > DateBefore30Second) {
            return [date compare:DateBefore5Second] == NSOrderedDescending;
        }
        else {
            return FALSE;
        }
    }];
    
    NSArray* aryFilterGps = [gpsArray filteredArrayUsingPredicate:predicate];
    NSArray* aryFilterAccel = [accelArray filteredArrayUsingPredicate:predicate];
    NSArray* aryFilterCompass = [compassArray filteredArrayUsingPredicate:predicate];
    NSArray* aryFilterGyroScope = [gyroScope filteredArrayUsingPredicate:predicate];
    NSArray* aryFilterContext = [contextArray filteredArrayUsingPredicate:predicatelong];
    NSArray* aryFilterCloud = [cloudArray filteredArrayUsingPredicate:predicatelong];
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GPS"];
    
    for (NSDictionary* dic in aryFilterGps)
    {
        GpsObject * gpsObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (gpsObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",gpsObject.lat,gpsObject.log,gpsObject.height,gpsObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n",@"ACCEL"];
    
    for (NSDictionary* dic in aryFilterAccel)
    {
        AccelObject * accelObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (accelObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",accelObject.x,accelObject.y,accelObject.z,accelObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"COMPASS"];
    
    for (NSDictionary* dic in aryFilterCompass)
    {
        CompassObject * compassObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (compassObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@",compassObject.magHeading,compassObject.trueHeading,compassObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GYRO"];
    for (NSDictionary* dic in aryFilterGyroScope)
    {
        GyroScopeObject * gyroScopeObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (gyroScopeObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",gyroScopeObject.x,gyroScopeObject.y,gyroScopeObject.z,gyroScopeObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"CONTEXT"];
    for (NSDictionary* dic in aryFilterContext)
    {
        ContextObject * contextObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (contextObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@",contextObject.contextValue,contextObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"CLOUDTHINK"];
    for (NSDictionary* dic in aryFilterCloud)
    {
        CloudObject * cloudObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@",cloudObject.cloudValue, cloudObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GROUND"];
    for (NSDictionary* dic in aryFilterCloud)
    {
        CloudObject * cloudObject = [dic allValues] && [[dic allValues] count] > 0 ? [[dic allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@", cloudObject.checkin, cloudObject.timeStamp];
        }
    }
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"END"];
    
    NSLog(@"TCP send Data : %@",strFileContent);
    
    NSData* data = [strFileContent dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:-1 tag:0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    // Backgrounding doesn't seem to be supported on the simulator yet
    [sock performBlock:^{
        if ([sock enableBackgroundingOnSocket])
        {
            NSLog(@"Enabled backgrounding on socket");
        }
        else
        {
            NSLog(@"Enabling backgrounding failed!");
        }
    }];
    [self sendDataViaTCP];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
	
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"HTTP Response:\n%@", httpResponse);
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

@end

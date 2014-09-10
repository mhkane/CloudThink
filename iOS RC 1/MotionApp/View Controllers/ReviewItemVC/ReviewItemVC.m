//
//  ReviewVC.m

#import "ReviewItemVC.h"
#import "ReviewItemCell.h"
#import <MessageUI/MessageUI.h>
#import "GpsObject.h"
#import "AccelObject.h"
#import "GyroScopeObject.h"
#import "CompassObject.h"
#include <CFNetwork/CFNetwork.h>
#import "NetworkManager.h"
#import "RecordNameEditVC.h"
#import "ContextObject.h"
#import "CloudObject.h"

enum {
    kSendBufferSize = 32768
};


@interface ReviewItemVC ()<MFMailComposeViewControllerDelegate, NSStreamDelegate>
{
    NSMutableArray * keysArray;
    NSMutableDictionary * dic;
    NSDateFormatter * formatter;
    MFMailComposeViewController * objMFMailComposeViewController;
    NSString * urlString;
    NSString * userNameString;
    NSString * passwordString;
    NSUserDefaults * userDefaults;
    RecordObject* recordObject;
}

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;

- (IBAction)sendFTP:(id)sender;
- (IBAction)sendTCP:(id)sender;

@end


@implementation ReviewItemVC
{
    uint8_t     _buffer[kSendBufferSize];
}

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
    // Do any additional setup after loading the view from its nib.
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    urlString = [userDefaults objectForKey:kUSER_DEFAULT_FTPNAME];
    userNameString = [userDefaults objectForKey:kUSER_DEFAULT_FTPUSER];
    passwordString = [userDefaults objectForKey:kUSER_DEFAULT_FTPPASS];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
}

- (void)setRecordIndex:(int)nIndex
{
    m_nIndexRecord = nIndex;
    recordObject = [recordsArray objectAtIndex:nIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * header = [keysArray objectAtIndex:section];
    NSMutableArray * temp = [dic objectForKey:header];
    return temp.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewItemCell * cell = (ReviewItemCell *) [tableView dequeueReusableCellWithIdentifier:@"ReviewItemCell"];
    if (cell == NULL)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReviewItemCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString * header = [keysArray objectAtIndex:indexPath.section];
    NSMutableArray * temp = [dic objectForKey:header];
    NSString * text = [temp objectAtIndex:indexPath.row];
    if (indexPath.section == 0)
    {
        //Section 0
        
        if (indexPath.row == 0)
        {
            [cell CellText:text CellTextForValue:recordObject.record_name];
        }
        else if (indexPath.row == 1)
        {
            [cell CellText:text CellTextForValue:[formatter stringFromDate:recordObject.record_time]];
        }
        else if (indexPath.row == 2)
        {
            [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%d",recordObject.record_duration]];
        }
    }
    else
    {
        //Section 1
        
        if (indexPath.row == 0)
        {
            if (recordObject.isGpsOn == 1)
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle.png"]];
            }
            else
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle_red.png"]];
            }
        }
        else if (indexPath.row == 1)
        {
            if (recordObject.isAccOn == 1)
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle.png"]];
            }
            else
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle_red.png"]];
            }
        }
        else if (indexPath.row == 2)
        {
            if (recordObject.isComOn == 1)
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle.png"]];
            }
            else
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle_red.png"]];
            }
            
        }
        else if (indexPath.row == 3)
        {
            if (recordObject.isGyroOn == 1)
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle.png"]];
            }
            else
            {
                [cell CellText:text CellImage:[UIImage imageNamed:@"circle_red.png"]];
            }
        }
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
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        RecordNameEditVC * recordNameEditVC = [[RecordNameEditVC alloc]initWithNibName:@"RecordNameEditVC_5" bundle:nil];
        [recordNameEditVC setRecordIndex:m_nIndexRecord];
        [self.navigationController pushViewController:recordNameEditVC animated:YES];
    }
}

- (IBAction)backbtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Send Email with txt file
- (IBAction)sendEmailBtn:(id)sender
{
    NSError *error;
    NSMutableString *strFileContent = [NSMutableString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                                 pathForResource: @"SensorValues" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [pathList  objectAtIndex:0];
    NSLog(@"path: %@",path);
    path = [NSString stringWithFormat:@"%@/SensorValues.txt",path];
    [strFileContent writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
    
    
    if(error)
    {  //Handle error
        
    }
    
    NSLog(@"File content : %@ ", strFileContent);
    
    
    [strFileContent appendFormat:@"\n%@\n ",@"GPS"];
    
    for (NSDictionary* diction in recordObject.gpsObject)
    {
        GpsObject * gpsObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (gpsObject)
        {
            [strFileContent appendFormat:@"\n%@, %@, %@, %@",gpsObject.lat,gpsObject.log,gpsObject.height,gpsObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\n%@\n",@"Accel."];
    
    for (NSDictionary* diction  in recordObject.accelObject)
    {
        AccelObject * accelObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (accelObject)
        {
            [strFileContent appendFormat:@"\n%@, %@, %@, %@",accelObject.x,accelObject.y,accelObject.z,accelObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\n%@\n ",@"Compass"];
    
    for (NSDictionary* diction in recordObject.compassObject)
    {
        CompassObject * compassObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (compassObject)
        {
            [strFileContent appendFormat:@"\n%@, %@, %@",compassObject.magHeading,compassObject.trueHeading,compassObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\n%@\n ",@"Gyroscope"];
    for (NSDictionary* diction  in recordObject.gyroScopeObject)
    {
        GyroScopeObject * gyroScopeObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (gyroScopeObject)
        {
            [strFileContent appendFormat:@"\n%@, %@, %@, %@",gyroScopeObject.x,gyroScopeObject.y,gyroScopeObject.z,gyroScopeObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\n%@\n ",@"Context"];
    for (NSDictionary* diction  in recordObject.contextArray)
    {
        ContextObject * contextObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (contextObject)
        {
            [strFileContent appendFormat:@"\n%@, %@",contextObject.contextValue,contextObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\n%@\n ",@"CloudThink"];
    for (NSDictionary* diction  in recordObject.cloudArray)
    {
        CloudObject * cloudObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\n%@, %@",cloudObject.cloudValue, cloudObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\n%@\n ",@"Ground"];
    for (NSDictionary* diction  in recordObject.cloudArray)
    {
        CloudObject * cloudObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\n%@, %@", cloudObject.checkin, cloudObject.timeStamp];
        }
    }
    
    
    NSLog(@"str: %@",strFileContent);
    
    [strFileContent writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
    
    objMFMailComposeViewController = [[MFMailComposeViewController alloc]init];
    objMFMailComposeViewController.mailComposeDelegate = self;
    
    NSString * receipt = [userDefaults objectForKey:kUSER_DEFAULT_EMAIL];
    [objMFMailComposeViewController setToRecipients:[[NSArray alloc] initWithObjects:receipt, nil]];
    [objMFMailComposeViewController setSubject:@"Log File"];
    NSString *messageBody = @"Please find the attached log file.";
    [objMFMailComposeViewController setMessageBody:messageBody isHTML:NO];
    
    NSData * fileData = [NSData dataWithContentsOfFile:path];
    [objMFMailComposeViewController addAttachmentData:fileData mimeType:@"text/plain" fileName:@"SensorValues"];
    
    [self presentViewController:objMFMailComposeViewController animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if ((error == nil) && (result == MFMailComposeResultSent))
    {
        NSLog(@"error value: %@", error);
        NSLog(@"result value: %d", result);
        UIAlertView *errorMailAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Email has been sent successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorMailAlert show];
        [self dismissViewControllerAnimated:YES completion:Nil];
        
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}


//Send File through FTP Server
- (IBAction)sendFTP:(id)sender
{
    if ( ! self.isSending )
    {
        // User the tag on the UIButton to determine which image to send.
        
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [pathList  objectAtIndex:0];
        NSLog(@"path: %@",path);
        path = [NSString stringWithFormat:@"%@/SensorValues.txt",path];
        
        [self startSend:path];
    }
}

- (IBAction)sendTCP:(id)sender {
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

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (void)startSend:(NSString *)filePath
{
    BOOL                    success;
    NSURL *                 url;
    
    urlString = [userDefaults objectForKey:kUSER_DEFAULT_FTPNAME];
    if (!urlString)
    {
        return;
    }
    url = [[NetworkManager sharedInstance] smartURLForString:urlString];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success)
    {
        //self.statusLabel.text = @"Invalid URL";
    }
    else
    {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        //assert(self.networkStream != nil);
        
        
        userNameString = [userDefaults objectForKey:kUSER_DEFAULT_FTPUSER];
        if ([userNameString length] != 0)
        {
            success = [self.networkStream setProperty:userNameString forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            passwordString = [userDefaults objectForKey:kUSER_DEFAULT_FTPPASS];
            success = [self.networkStream setProperty:passwordString forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Tell the UI we're sending.
        
        [self sendDidStart];
    }
}

- (void)sendDidStart
{
    //[self.activityIndicator startAnimating];
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)updateStatus:(NSString *)statusString
{
    //assert(statusString != nil);
    //self.statusLabel.text = statusString;
}

- (void)viewWillAppear:(BOOL)animated
{
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSSS"];
    
    keysArray = [[NSMutableArray alloc]initWithObjects:@"Summary", @"Sensors", nil];
    NSMutableArray * runsArray = [[NSMutableArray alloc]initWithObjects:@"Name", @"Time", @"Duration", nil];
    NSMutableArray * lastReadingsArray = [[NSMutableArray alloc]initWithObjects:@"GPS", @"Accel.", @"Compass", @"Gyroscopes", nil];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setObject:runsArray forKey:@"Summary"];
    [dic setObject:lastReadingsArray forKey:@"Sensors"];
    
    [tableview reloadData];
}

- (void)setEmailOptionValueForRename:(NSString *)str
{
    recordObject.record_name = str;
    [tableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil)
    {
        statusString = @"Put succeeded";//success
    }
    
    // [self.activityIndicator stopAnimating];
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    NSMutableString* strFileContent = [NSMutableString stringWithString:@"START,IOS"];
    [strFileContent appendFormat:@"\r\n%@,%@ ",@"USER", [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] ? [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] : @""];
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GPS"];
    
    for (NSDictionary* diction in recordObject.gpsObject)
    {
        GpsObject * gpsObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (gpsObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",gpsObject.lat,gpsObject.log,gpsObject.height,gpsObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n",@"ACCEL"];
    
    for (NSDictionary* diction  in recordObject.accelObject)
    {
        AccelObject * accelObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (accelObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",accelObject.x,accelObject.y,accelObject.z,accelObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"COMPASS"];
    
    for (NSDictionary* diction in recordObject.compassObject)
    {
        CompassObject * compassObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (compassObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@",compassObject.magHeading,compassObject.trueHeading,compassObject.timeStamp];
        }
    }
    
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GYRO"];
    for (NSDictionary* diction  in recordObject.gyroScopeObject)
    {
        GyroScopeObject * gyroScopeObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (gyroScopeObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@, %@, %@",gyroScopeObject.x,gyroScopeObject.y,gyroScopeObject.z,gyroScopeObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"CONTEXT"];
    for (NSDictionary* diction  in recordObject.contextArray)
    {
        ContextObject * contextObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (contextObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@",contextObject.contextValue,contextObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"CLOUDTHINK"];
    for (NSDictionary* diction  in recordObject.cloudArray)
    {
        CloudObject * cloudObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@",cloudObject.cloudValue, cloudObject.timeStamp];
        }
    }
    
    [strFileContent appendFormat:@"\r\n%@\r\n ",@"GROUND"];
    for (NSDictionary* diction  in recordObject.cloudArray)
    {
        CloudObject * cloudObject = [diction allValues] && [[diction allValues] count] > 0 ? [[diction allValues] objectAtIndex:0] : nil;
        if (cloudObject)
        {
            [strFileContent appendFormat:@"\r\n%@, %@", cloudObject.checkin, cloudObject.timeStamp];
        }
    }
    [strFileContent appendFormat:@"\n%@\n ",@"END"];
    
    NSLog(@"TCP send Data : %@",strFileContent);

    NSData* data = [strFileContent dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:-1 tag:0];
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

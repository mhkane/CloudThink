//
//  SettingsVC.m

#import "SettingsVC.h"
#import "SettingsCell.h"
#import "GpsSettingVC.h"
#import "AccelSettingVC.h"
#import "CompassSettingVC.h"
#import "GyroSettingVC.h"
#import "FtpNameSettingVC.h"
#import "FtpUserSettingVC.h"
#import "FtpPasswordSettingVC.h"
#import "FtpPortVC.h"
#import "EmailSettingsVC.h"
#import "VinSettingsVC.h"
#import "TcpUserSettingVC.h"
#import "TcpPortVC.h"
#import "TcpNameSettingVC.h"

@interface SettingsVC ()
{
    NSMutableArray * keysArray;
    NSMutableDictionary * dic;
    NSUserDefaults * userDegaults;
    int isGyroOn;
    int isComOn;
    int isGpsOn;
    int isAccOn;
//    NSString * gpsValue;
    NSString * accValue;
    NSString * comValue;
    NSString * gyroValue;
    NSString * vinStr;
    NSString * ftpname;
    NSString * ftpuser;
    NSString * ftppwd;
    NSString * ftpport;
    NSString * emailStr;
    
    NSString * tcpserver;
    NSString * tcpport;
    NSString * tcpuserid;
    
    NSUserDefaults * userDefaults;
}

@end

@implementation SettingsVC

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
    isGyroOn = 1;
    isGpsOn = 1;
    isComOn = 1;
    isAccOn = 1;
    userDegaults = [NSUserDefaults standardUserDefaults];
    
    keysArray = [[NSMutableArray alloc]initWithObjects:@"Sensors", @"Sample Frequency", @"FTP Capture Server", @"TCP Capture Server", @"Email", nil];
    NSMutableArray * sensorsArray = [[NSMutableArray alloc]initWithObjects:@"GPS", @"Accelerometers", @"Compass", @"Gyroscopes", nil];
    NSMutableArray * sampleArray = [[NSMutableArray alloc]initWithObjects:@"GPS", @"Accelerometers", @"Compass", @"Gyroscopes", @"VIN(CT)", nil];
    NSMutableArray * broadCastArray = [[NSMutableArray alloc]initWithObjects:@"FTP Name", @"FTP User", @"FTP Pass", @"FTP Port",  nil];
    NSMutableArray * tcpCaptureArray = [[NSMutableArray alloc]initWithObjects:@"Server Address", @"TCP Port", @"User ID",  nil];
    NSMutableArray * emailArray = [[NSMutableArray alloc]initWithObjects:@"Address", nil];

    dic = [[NSMutableDictionary alloc]init];
    [dic setObject:sensorsArray forKey:@"Sensors"];
    [dic setObject:sampleArray forKey:@"Sample Frequency"];
    [dic setObject:broadCastArray forKey:@"FTP Capture Server"];
    [dic setObject:tcpCaptureArray forKey:@"TCP Capture Server"];
    [dic setObject:emailArray forKey:@"Email"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * header = [keysArray objectAtIndex:section];
    NSMutableArray * temp = [dic objectForKey:header];
    return temp.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strIdentifier = @"SettingsCell";
    SettingsCell * cell = (SettingsCell *) [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == NULL)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString * header = [keysArray objectAtIndex:indexPath.section];
    NSMutableArray * temp = [dic objectForKey:header];
    NSString * text = [temp objectAtIndex:indexPath.row];
    cell.listSwitch.tag = indexPath.row;
    [cell.listSwitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            int switchValue = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISGPSON];
            [cell CellText:text CellSwitchValue:switchValue];
        }
        else if (indexPath.row == 1)
        {
            int switchValue = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISACCON];
            [cell CellText:text CellSwitchValue:switchValue];
        }
        else if (indexPath.row == 2)
        {
            int switchValue = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISCOMON];
            [cell CellText:text CellSwitchValue:switchValue];
        }
        else if (indexPath.row == 3)
        {
            int switchValue = (int)[userDefaults integerForKey:kUSER_DEFAULT_ISGYROON];
            [cell CellText:text CellSwitchValue:switchValue];
        }

    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
//            [cell CellText:text CellTextForValue:gpsValue];
            [cell CellText:text CellTextForValue:(int)[userDefaults integerForKey:kUSER_DEFAULT_ISGPSON] ? @"Always On" : @"Context Only"];
        }
        else if(indexPath.row == 1)
        {
            [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@ Hz", accValue]];
            NSLog(@"accValue: %@",accValue);
        }
        else if(indexPath.row == 2)
        {
            [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@ Hz", comValue]];
            NSLog(@"comValue: %@",comValue);
        }
        else if(indexPath.row == 3)
        {
            [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@ Hz", gyroValue]];
            NSLog(@"gyroValue: %@",gyroValue);
        }
        else if(indexPath.row == 4)
        {
            [cell CellText:text CellTextForValue:[NSString stringWithFormat:@"%@", vinStr]];
            NSLog(@"vinValue: %@",vinStr);
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [cell CellText:text CellTextForValue:ftpname];
        }
        else if (indexPath.row == 1)
        {
            [cell CellText:text CellTextForValue:ftpuser];
        }
        else if (indexPath.row == 2)
        {
            NSString* str = @"";
            for (int i=0; i < ftppwd.length; i++) {
                str = [str stringByAppendingString:@"*"];
            }
            [cell CellText:text CellTextForValue:str];
        }
        else if (indexPath.row == 3)
        {
            [cell CellText:text CellTextForValue:ftpport];
        }
    }
    else if (indexPath.section == 3)
    {
        switch (indexPath.row) {
            case 0:
                [cell CellText:text CellTextForValue:tcpserver];
                break;
            case 1:
                [cell CellText:text CellTextForValue:tcpport];
                break;
            case 2:
                [cell CellText:text CellTextForValue:tcpuserid];
                break;
        }
    }
    else if (indexPath.section == 4)
    {
        [cell CellText:text CellTextForValue:emailStr];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            //Gps.
//            GpsSettingVC * vc = [[GpsSettingVC alloc]initWithNibName:@"GpsSettingVC_5" bundle:Nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //Acc
            AccelSettingVC * vc = [[AccelSettingVC alloc]initWithNibName:@"AccelSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //Compass
            CompassSettingVC * vc = [[CompassSettingVC alloc]initWithNibName:@"CompassSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3)
        {
            //GyroScope
            GyroSettingVC * gyroSettingVC = [[GyroSettingVC alloc]initWithNibName:@"GyroSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:gyroSettingVC animated:YES];
        }
        else if (indexPath.row == 4)
        {
            //VIN
            VinSettingsVC * vinSettingsVC = [[VinSettingsVC alloc]initWithNibName:@"VinSettingsVC_5" bundle:Nil];
            [self.navigationController pushViewController:vinSettingsVC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            //Ftp Url Name
            FtpNameSettingVC * ftpNameSettingVC = [[FtpNameSettingVC alloc]initWithNibName:@"FtpNameSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:ftpNameSettingVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //Ftp User Name
            FtpUserSettingVC * ftpUserSettingVC = [[FtpUserSettingVC alloc]initWithNibName:@"FtpUserSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:ftpUserSettingVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //Ftp Password
            FtpPasswordSettingVC * ftpPasswordSettingVC = [[FtpPasswordSettingVC alloc]initWithNibName:@"FtpPasswordSettingVC_5" bundle:Nil];
            [self.navigationController pushViewController:ftpPasswordSettingVC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            //Ftp Port
            FtpPortVC * ftpPortVC = [[FtpPortVC alloc]initWithNibName:@"FtpPortVC_5" bundle:Nil];
            [self.navigationController pushViewController:ftpPortVC animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        // TCP Info
        if (indexPath.row == 0)
        {
            //Tcp Url Name
            TcpNameSettingVC * vc = [[TcpNameSettingVC alloc] initWithNibName:@"TcpNameSettingVC" bundle:Nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //Tcp Port
            TcpPortVC * vc = [[TcpPortVC alloc]initWithNibName:@"TcpPortVC" bundle:Nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //Tcp User Name
            TcpUserSettingVC * vc = [[TcpUserSettingVC alloc]initWithNibName:@"TcpUserSettingVC" bundle:Nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 4)
    {
        //Email
        EmailSettingsVC * emailSettingsVC = [[EmailSettingsVC alloc]initWithNibName:@"EmailSettingsVC_5" bundle:Nil];
        [self.navigationController pushViewController:emailSettingsVC animated:YES];
    }
}


- (void)switchTapped:(id)sender
{
    UISwitch * listSwitch = (UISwitch *)sender;
    if (listSwitch.tag == 0)
    {
        isGpsOn = listSwitch.isOn;
    }
    else if (listSwitch.tag == 1)
    {
        isAccOn = listSwitch.isOn;
    }
    else if (listSwitch.tag == 2)
    {
        isComOn = listSwitch.isOn;
    }
    else if (listSwitch.tag == 3)
    {
        isGyroOn = listSwitch.isOn;
    }
    
    [userDefaults setInteger:isGpsOn forKey:kUSER_DEFAULT_ISGPSON];
    [userDegaults setInteger:isGyroOn forKey:kUSER_DEFAULT_ISGYROON];
    [userDegaults setInteger:isComOn forKey:kUSER_DEFAULT_ISCOMON];
    [userDegaults setInteger:isAccOn forKey:kUSER_DEFAULT_ISACCON];
    [userDegaults synchronize];
    [_m_tbMain reloadData];
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

- (void)viewWillAppear:(BOOL)animated
{
//    gpsValue = [userDefaults objectForKey:kUSER_DEFAULT_GPSVALUE] && ![[userDefaults objectForKey:kUSER_DEFAULT_GPSVALUE] isEqualToString:@""] ? @"Context Only" : [userDefaults objectForKey:kUSER_DEFAULT_GPSVALUE];
    accValue = [userDefaults objectForKey:kUSER_DEFAULT_ACCVALUE] && ![[userDefaults objectForKey:kUSER_DEFAULT_ACCVALUE] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_ACCVALUE] : @"0";
    comValue = [userDefaults objectForKey:kUSER_DEFAULT_COMVALUE] && ![[userDefaults objectForKey:kUSER_DEFAULT_COMVALUE] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_COMVALUE] : @"0";
    gyroValue = [userDefaults objectForKey:kUSER_DEFAULT_GYROVALUE] && ![[userDefaults objectForKey:kUSER_DEFAULT_GYROVALUE] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_GYROVALUE] : @"0";
    vinStr = [userDefaults objectForKey:kUSER_DEFAULT_VINVALUE] && ![[userDefaults objectForKey:kUSER_DEFAULT_VINVALUE] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_VINVALUE] : @"";
    
    ftpname = [userDefaults objectForKey:kUSER_DEFAULT_FTPNAME];
    ftpuser = [userDefaults objectForKey:kUSER_DEFAULT_FTPUSER];
    ftppwd = [userDefaults objectForKey:kUSER_DEFAULT_FTPPASS];
    ftpport = [userDefaults objectForKey:kUSER_DEFAULT_FTPPORT];
    
    emailStr = [userDefaults objectForKey:kUSER_DEFAULT_EMAIL];
    
    tcpserver = [userDefaults objectForKey:kUSER_DEFAULT_TCPSEVERADDRESS] && ![[userDefaults objectForKey:kUSER_DEFAULT_TCPSEVERADDRESS] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_TCPSEVERADDRESS] : @"";
    tcpport = [userDefaults objectForKey:kUSER_DEFAULT_TCPPORT] && ![[userDefaults objectForKey:kUSER_DEFAULT_TCPPORT] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_TCPPORT] : @"";
    tcpuserid = [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] && ![[userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] isEqualToString:@""] ? [userDefaults objectForKey:kUSER_DEFAULT_TCPUSERID] : @"";
    

    [_m_tbMain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end

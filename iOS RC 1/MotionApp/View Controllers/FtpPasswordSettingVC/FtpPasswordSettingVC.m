//
//  FtpPasswordSettingVC.m

#import "FtpPasswordSettingVC.h"
#import "SettingsValueCell.h"

@interface FtpPasswordSettingVC ()

@end

@implementation FtpPasswordSettingVC

@synthesize value;

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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsValueCell * cell = (SettingsValueCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsValueCell"];
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsValueCell" owner:self options:Nil] objectAtIndex:0];
    }
    
    cell.settingsValueTextField.text = self.value;
    cell.settingsValueTextField.delegate = self;
    cell.settingsValueTextField.secureTextEntry = YES;
    [cell.settingsValueTextField becomeFirstResponder];
    return cell;
}

- (NSString*)value
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_DEFAULT_FTPPASS];
}

-(IBAction)settingBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kUSER_DEFAULT_FTPPASS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

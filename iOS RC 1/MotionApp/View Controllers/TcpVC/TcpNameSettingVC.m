//
//  AccelSettingVC.m

#import "TcpNameSettingVC.h"
#import "SettingsValueCell.h"

@interface TcpNameSettingVC ()

@end

@implementation TcpNameSettingVC

@synthesize value;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [cell.settingsValueTextField becomeFirstResponder];
    return cell;
}

- (NSString*)value
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_DEFAULT_TCPSEVERADDRESS];
}

-(IBAction)settingBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kUSER_DEFAULT_TCPSEVERADDRESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* completeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [Global validateFtpName:completeText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

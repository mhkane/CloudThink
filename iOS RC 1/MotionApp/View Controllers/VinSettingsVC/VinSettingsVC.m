//
//  VinSettingsVC.m

#import "VinSettingsVC.h"
#import "SettingsValueCell.h"

@interface VinSettingsVC ()
{
    UITextField* m_textfield;
}
@end

@implementation VinSettingsVC

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
    m_textfield = cell.settingsValueTextField;
    [cell.settingsValueTextField becomeFirstResponder];
    return cell;
}


-(IBAction)settingBtn:(id)sender
{
    if (m_textfield.text.length == 17 || m_textfield.text.length == 0)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"VIN length must be 17 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kUSER_DEFAULT_VINVALUE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)value
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSER_DEFAULT_VINVALUE];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* completeText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL bReturn = [Global validateVIN:completeText] && completeText.length <= 17;
    if (bReturn)
    {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

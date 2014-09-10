//
//  RecordNameEditVC.m

#import "RecordNameEditVC.h"
#import "SettingsValueCell.h"
#import "RecordObject.h"

@interface RecordNameEditVC ()
{
    RecordObject* object;
}
@end

@implementation RecordNameEditVC

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

- (void)setRecordIndex:(int)nIndex
{
    m_nRecordIndex = nIndex;
    object = [recordsArray objectAtIndex:m_nRecordIndex];
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
    [cell.settingsValueTextField becomeFirstResponder];
    return cell;
}

- (NSString*)value
{
    return object.record_name;
}


-(IBAction)settingBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        object.record_name = textField.text;
        [recordsArray replaceObjectAtIndex:m_nRecordIndex withObject:object];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

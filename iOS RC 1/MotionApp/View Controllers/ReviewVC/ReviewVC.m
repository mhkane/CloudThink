//
//  ReviewVC.m

#import "ReviewVC.h"
#import "ReviewCell.h"
#import "ReviewItemVC.h"
#import "RecordObject.h"
#import "DataBaseManager.h"

@interface ReviewVC ()
{
    NSDateFormatter * formatter;
    int flagForEditBtn;
}

@end

@implementation ReviewVC

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
    flagForEditBtn = 0;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss:SSSS"];
}

- (void)viewWillAppear:(BOOL)animated
{
//    DataBaseManager * databaseManager = [[DataBaseManager alloc]init];
//    self.recordsArray = [databaseManager selectRecords];
    [reviewTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewCell * cell = (ReviewCell *) [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    if (cell == NULL)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    RecordObject * recordObject = [recordsArray objectAtIndex:indexPath.row];
    [cell CellTextName:recordObject.record_name CellDate:[formatter stringFromDate:recordObject.record_time]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewItemVC * reviewItemVC = [[ReviewItemVC alloc]initWithNibName:@"ReviewItemVC_5" bundle:Nil];
    [reviewItemVC setRecordIndex:(int)indexPath.row];
    [self.navigationController pushViewController:reviewItemVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [recordsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



- (BOOL)isIphone5
{
    BOOL value = YES;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960) {
                //NSLog(@"iPhone 4 Resolution");
                value = NO;
            }
            if(result.height == 1136) {
                //NSLog(@"iPhone 5 Resolution");
                value = YES;
            }
        }
        else{
            //NSLog(@"Standard Resolution");
        }
    }
    return value;
}

- (IBAction)editBtn:(id)sender
{
    if (flagForEditBtn == 0)
    {
        [editBtn setTitle:@"Done" forState:UIControlStateNormal];
        [reviewTableView setEditing:YES];
        flagForEditBtn = 1;
    }
    else
    {
        [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [reviewTableView setEditing:NO];
        flagForEditBtn = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

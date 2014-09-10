//
//  RecordCell.h

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
{
}
@property (weak, nonatomic) IBOutlet UILabel *listName;
@property (weak, nonatomic) IBOutlet UIImageView *listImgView;
@property (weak, nonatomic) IBOutlet UILabel *listValue;

- (void)CellText:(NSString *)text CellTextForValue:(NSString *)value;
- (void)CellText:(NSString *)text CellImage:(UIImage *)img;

@end

//
//  ReviewCell.h

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell
{
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * dateLabel;
}

- (void)CellTextName:(NSString *)name CellDate:(NSString *)date;

@end

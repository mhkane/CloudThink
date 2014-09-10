//
//  ReviewItemCell.h

#import <UIKit/UIKit.h>

@interface ReviewItemCell : UITableViewCell
{
    IBOutlet UILabel * listName;
    IBOutlet UIImageView * listImgView;
    IBOutlet UILabel * listValue;
}

- (void)CellText:(NSString *)text CellTextForValue:(NSString *)value;
- (void)CellText:(NSString *)text CellImage:(UIImage *)img;


@end

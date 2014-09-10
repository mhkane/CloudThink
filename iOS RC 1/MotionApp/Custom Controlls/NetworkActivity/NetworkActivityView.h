//
//  NetworkActivityView.h

#import <UIKit/UIKit.h>

@interface NetworkActivityView : UIView
{
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)initIndicator;
- (void)startActivity;
- (void)stopActivity;
@end

//
//  NetworkActivityView.m

#import "NetworkActivityView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NetworkActivityView

@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setAlpha:0.1];
        
        
    }
    return self;
}

- (void)initIndicator
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setHidesWhenStopped:NO];
    
    float x = self.frame.size.width/2 - 18.5;
    float y = self.frame.size.height/2 - 18.5;
    
    [self.activityIndicator setFrame:CGRectMake(x, y, 37, 37)];
    
    [self addSubview:self.activityIndicator];
    
    x = self.frame.size.width/2 - (self.activityIndicator.bounds.size.height*1.5);
    y = self.frame.size.height/2 - (self.activityIndicator.bounds.size.height*1.5);
    
    CGFloat border = self.activityIndicator.bounds.size.height / 2;
    CGRect hudFrame = CGRectMake(x, y, self.activityIndicator.bounds.size.height*3, self.activityIndicator.bounds.size.height*3);
    UIView *hud = [[UIView alloc] initWithFrame:hudFrame];
    hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67];
    hud.layer.cornerRadius = border;
    [self addSubview:hud];
    [self sendSubviewToBack:hud];
    
    hud = nil;
}

- (void)startActivity
{
    [self.activityIndicator startAnimating];
}

- (void)stopActivity
{
    [self.activityIndicator stopAnimating];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

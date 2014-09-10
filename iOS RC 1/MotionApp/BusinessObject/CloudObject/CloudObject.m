//
//  CloudObject.m

#import "CloudObject.h"

@implementation CloudObject

@synthesize timeStamp;
@synthesize cloudValue;
@synthesize cloudThinkImage;
@synthesize checkin;

- (id)init
{
    self = [super init];
    if (self)
    {
        timeStamp = @"";
        cloudValue = @"";
        cloudThinkImage = @"";
        checkin = @"";
    }
    return self;
}

@end

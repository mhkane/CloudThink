//
//  ContextObject.m

#import "ContextObject.h"

@implementation ContextObject

@synthesize timeStamp;
@synthesize contextValue;


- (id)init
{
    self = [super init];
    if (self)
    {
        timeStamp = @"";
        contextValue = @"";
    }
    return self;
}


@end

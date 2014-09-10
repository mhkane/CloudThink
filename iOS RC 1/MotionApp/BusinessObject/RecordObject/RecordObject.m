//
//  RecordObject.m

#import "RecordObject.h"

@implementation RecordObject

@synthesize record_id;
@synthesize record_name;
@synthesize record_time;
@synthesize record_duration;
@synthesize gpsObject;
@synthesize gyroScopeObject;
@synthesize accelObject;
@synthesize compassObject;
@synthesize contextArray;
@synthesize cloudArray;
@synthesize isGpsOn;
@synthesize isAccOn;
@synthesize isComOn;
@synthesize isGyroOn;

- (id)init
{
    self = [super init];
    if (self)
    {
        gpsObject = [[NSMutableArray alloc]init];
        gyroScopeObject = [[NSMutableArray alloc]init];
        accelObject = [[NSMutableArray alloc]init];
        compassObject = [[NSMutableArray alloc]init];
        contextArray = [[NSMutableArray alloc]init];
        cloudArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end

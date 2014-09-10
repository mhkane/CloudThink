//
//  RecordObject.h

#import <Foundation/Foundation.h>

@interface RecordObject : NSObject
{
    int record_id;
    NSString * record_name;
    NSDate * record_time;
    int record_duration;
    NSMutableArray * gpsObject;
    NSMutableArray * gyroScopeObject;
    NSMutableArray * accelObject;
    NSMutableArray * compassObject;
    NSMutableArray * contextArray;
    NSMutableArray * cloudArray;
    int isGpsOn;
    int isGyroOn;
    int isAccOn;
    int isComOn;
}

@property(nonatomic, assign) int record_id;
@property(nonatomic, strong) NSString * record_name;
@property(nonatomic, strong) NSDate * record_time;
@property(nonatomic, assign) int record_duration;
@property(nonatomic, strong) NSMutableArray * gpsObject;
@property(nonatomic, strong) NSMutableArray * gyroScopeObject;
@property(nonatomic, strong) NSMutableArray * accelObject;
@property(nonatomic, strong) NSMutableArray * compassObject;
@property(nonatomic, strong) NSMutableArray * contextArray;
@property(nonatomic, strong) NSMutableArray * cloudArray;
@property(nonatomic, assign) int isGpsOn;
@property(nonatomic, assign) int isGyroOn;
@property(nonatomic, assign) int isAccOn;
@property(nonatomic, assign) int isComOn;

@end

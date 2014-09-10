//
//  AccelObject.h

#import <Foundation/Foundation.h>

@interface AccelObject : NSObject
{
    int accel_id;
    int record_id;
    NSString * x;
    NSString * y;
    NSString * z;
    NSString * timeStamp;
}

@property(nonatomic, assign) int accel_id;
@property(nonatomic, assign) int record_id;
@property(nonatomic, strong) NSString *  x;
@property(nonatomic, strong) NSString *  y;
@property(nonatomic, strong) NSString *  z;
@property(nonatomic, strong) NSString *  timeStamp;


@end

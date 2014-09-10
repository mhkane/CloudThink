//
//  GyroScopeObject.h

#import <Foundation/Foundation.h>

@interface GyroScopeObject : NSObject
{
    int gyro_id;
    int record_id;
    NSString * x;
    NSString * y;
    NSString * z;
    NSString * timeStamp;
}

@property(nonatomic, assign) int gyro_id;
@property(nonatomic, assign) int record_id;
@property(nonatomic, strong) NSString * x;
@property(nonatomic, strong) NSString * y;
@property(nonatomic, strong) NSString * z;
@property(nonatomic, strong) NSString * timeStamp;

@end

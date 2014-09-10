//
//  GpsObject.h

#import <Foundation/Foundation.h>

@interface GpsObject : NSObject
{
    int gps_id;
    int record_id;
    NSString * lat;
    NSString * log;
    NSString * height;
    NSString * timeStamp;
}

@property(nonatomic, assign) int gps_id;
@property(nonatomic, assign) int record_id;
@property(nonatomic, strong) NSString * lat;
@property(nonatomic, strong) NSString * log;
@property(nonatomic, strong) NSString * height;
@property(nonatomic, strong) NSString * timeStamp;

@end

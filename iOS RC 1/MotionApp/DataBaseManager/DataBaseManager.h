//
//  DataBaseManager.h

#import <Foundation/Foundation.h>
#import "RecordObject.h"
#import "GpsObject.h"
#import "GyroScopeObject.h"
#import "AccelObject.h"
#import "CompassObject.h"

@interface DataBaseManager : NSObject


@property(nonatomic, strong) NSMutableArray * recordArray;

//RecordObject Methods
- (NSMutableArray *)selectRecords;
- (void)insertRecord:(RecordObject *)record;
- (void)updateRecord:(RecordObject *)record;
- (void)deleteRecord:(int )record_id;

//GpsObject Methods
- (NSMutableArray *)selectGps;
- (void)insertGps:(GpsObject *)gpsObj WithRecordId:(int) recordId;
- (void)deleteGps:(int)gps_id;

//GyroObject Methods
- (NSMutableArray *)selectGyro;
- (void)insertGyro:(GyroScopeObject *)gyroObj WithRecordId:(int) recordId;
- (void)deleteGyro:(int)gyro_id;

//AccelObject Methods
- (NSMutableArray *)selectAccel;
- (void)insertAccel:(AccelObject *)accelObj WithRecordId:(int) recordId;
- (void)deleteAccel:(int)accel_id;

//CompassObject Methods
- (NSMutableArray *)selectCompass;
- (void)insertCompass:(CompassObject *)compassObj WithRecordId:(int) recordId;
- (void)deleteCompass:(int)compass_id;

@end

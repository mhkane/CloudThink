//
//  Global.h
//  Motion App
//
//  Copyright (c) 2014 j_siegel. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUSER_DEFAULT_ISGPSON   @"kUSER_DEFAULT_ISGPSON"
#define kUSER_DEFAULT_ISACCON   @"kUSER_DEFAULT_ISACCON"
#define kUSER_DEFAULT_ISCOMON   @"kUSER_DEFAULT_ISCOMON"
#define kUSER_DEFAULT_ISGYROON  @"kUSER_DEFAULT_ISGYROON"

#define kUSER_DEFAULT_GPSVALUE  @"kUSER_DEFAULT_GPSVALUE"
#define kUSER_DEFAULT_ACCVALUE  @"kUSER_DEFAULT_ACCVALUE"
#define kUSER_DEFAULT_COMVALUE  @"kUSER_DEFAULT_COMVALUE"
#define kUSER_DEFAULT_GYROVALUE @"kUSER_DEFAULT_GYROVALUE"
#define kUSER_DEFAULT_VINVALUE  @"kUSER_DEFAULT_VINVALUE"

#define kUSER_DEFAULT_FTPNAME   @"kUSER_DEFAULT_FTPNAME"
#define kUSER_DEFAULT_FTPUSER   @"kUSER_DEFAULT_FTPUSER"
#define kUSER_DEFAULT_FTPPASS   @"kUSER_DEFAULT_FTPPASS"
#define kUSER_DEFAULT_FTPPORT   @"kUSER_DEFAULT_FTPPORT"


#define kUSER_DEFAULT_TCPSEVERADDRESS       @"kUSER_DEFAULT_TCPSEVERADDRESS"
#define kUSER_DEFAULT_TCPPORT               @"kUSER_DEFAULT_TCPPORT"
#define kUSER_DEFAULT_TCPUSERID             @"kUSER_DEFAULT_TCPUSERID"

#define kUSER_DEFAULT_EMAIL                 @"kUSER_DEFAULT_EMAIL"

@interface Global : NSObject

+ (BOOL)validateNumber:(NSString*)number;
+ (BOOL)validateFtpName:(NSString*)name;
+ (BOOL)validateVIN:(NSString*)name;
+ (BOOL)validEmailAddress:(NSString *)address;

@end

extern NSArray* m_gAryCheckin;
extern int m_gIndexCheckin;
extern NSMutableArray * recordsArray;
//
//  CompassObject.h

#import <Foundation/Foundation.h>

@interface CompassObject : NSObject
{
    int compass_id;
    int record_id;
    NSString * magHeading;
    NSString * trueHeading;
    NSString * timeStamp;
}

@property(nonatomic, assign) int compass_id;
@property(nonatomic, assign) int record_id;
@property(nonatomic, strong) NSString * magHeading;
@property(nonatomic, strong) NSString * trueHeading;
@property(nonatomic, strong) NSString * timeStamp;

@end

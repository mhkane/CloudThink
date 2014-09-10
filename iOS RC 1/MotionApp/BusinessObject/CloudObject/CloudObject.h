//
//  CloudObject.h

#import <Foundation/Foundation.h>

@interface CloudObject : NSObject
{
    NSString * timeStamp;
    NSString * cloudtValue;
    NSString * cloudThinkImage;
    NSString * checkin;
}

@property(strong, nonatomic) NSString * timeStamp;
@property(strong, nonatomic) NSString * cloudValue;
@property(strong, nonatomic) NSString * cloudThinkImage;
@property(strong, nonatomic) NSString * checkin;


@end

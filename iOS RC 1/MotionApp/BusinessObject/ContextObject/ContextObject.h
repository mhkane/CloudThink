//
//  ContextObject.h

#import <Foundation/Foundation.h>

@interface ContextObject : NSObject
{
    NSString * timeStamp;
    NSString * contextValue;
}

@property(strong, nonatomic) NSString * timeStamp;
@property(strong, nonatomic) NSString * contextValue;


@end

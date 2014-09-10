//
//  CloudThinkParserClass.h

#import <Foundation/Foundation.h>
#import "HttpWorker.h"

@protocol UpdateViewDelegate <NSObject>

@optional

- (void)updateView:(BOOL)isConnected;

@end


@interface CloudThinkParserClass : NSObject<DataParserDelegate>

@property(assign, nonatomic)id<UpdateViewDelegate>delegate;

@end

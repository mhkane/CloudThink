//
//  HttpWorker.h

#import <Foundation/Foundation.h>

@protocol DataParserDelegate <NSObject>

-(void)parseData:(NSData *)data;

@end

@interface HttpWorker : NSObject <NSURLConnectionDataDelegate>
{
    NSData *POSTReply;
}


@property (nonatomic, assign) id<DataParserDelegate>delegate;
@property (nonatomic, retain) UIViewController *parent;
@property(nonatomic) BOOL notShowNetworkActivity;
//@property (nonatomic,readonly) EventList * objEventList;
@property (nonatomic, retain) NSMutableData *responseData;

-(void)requestNetwork:(NSString *)strUrl;
-(void)requestPOSTNetwork:(NSString *)strUrl data:(NSData *)data;

@end

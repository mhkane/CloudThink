//
//  CloudThinkParserClass.m

#import "CloudThinkParserClass.h"


@implementation CloudThinkParserClass

- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

-(void)parseData:(NSData *)data
{
    
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str: %@",str);
    NSError * error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:&error];
    NSLog(@"json: %@",json);
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date1 = [formatter dateFromString:[json objectForKey:@"lastSeen"]];
    NSDate *date2 = [formatter dateFromString:[json objectForKey:@"requestTime"]];
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    NSLog(@"secondsBetween: %f",secondsBetween);
    BOOL isConnected = NO;
    if (secondsBetween < 300) // 5 minutes between last update
    {
        isConnected = YES;
    }
    else
    {
        isConnected = NO;
    }
    [self.delegate updateView:isConnected];
}

@end

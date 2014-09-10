//
//  HttpWorker.m

#import "HttpWorker.h"
#import "AppDelegate.h"

/**
 HttpWorker implementation - Network Layer part.
 NetManger will call this class 'start' method to start the Network Request.
 */
@implementation HttpWorker

@synthesize responseData;
@synthesize delegate;
@synthesize parent;
@synthesize notShowNetworkActivity;
//@synthesize objEventList;

-(void)requestNetwork:(NSString *)strUrl
{
    @try {
        
        if (!notShowNetworkActivity) {
            //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //[appDelegate showNetworkActivity];
        }
        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSLog(@"URL:  %@",url);
        
        NSString * username = @"rootApp";
        NSString * password = @"cloudcar12";
    
        NSString * simpleStr = [NSString stringWithFormat:@"%@:%@",username,password];
        NSData * dataOfStr = [simpleStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString * base64Str = [dataOfStr base64EncodedStringWithOptions:0];
        NSString * finalStrForAuthrization = [NSString stringWithFormat:@"Basic %@",base64Str];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:finalStrForAuthrization forHTTPHeaderField:@"Authorization"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [conn start];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)requestPOSTNetwork:(NSString *)strUrl data:(NSData *)data
{
    @try {
        if (responseData) {
            responseData = NULL;
        }
        if (!notShowNetworkActivity) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showNetworkActivity];
        }
        
        
        NSURL *url = [NSURL URLWithString:strUrl];
        NSLog(@"URL:  %@",url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        [conn start];
        NSLog(@"conn:  %@",conn);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError  %@",error);
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate hideNetworkActivity];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection didReceiveResponse:  %@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(responseData == NULL){
        responseData = [[NSMutableData alloc] init];
        [responseData appendData:data];
    }else{
        [responseData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    [delegate parseData:responseData];
}


@end

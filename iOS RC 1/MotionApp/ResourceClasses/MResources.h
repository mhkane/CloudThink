//  MResources.h

#import <Foundation/Foundation.h>
#import "CloudThinkParserClass.h"

@interface MResources : NSObject
{
    CloudThinkParserClass * cloudThinkParserClass;
}


@property (nonatomic, retain) CloudThinkParserClass * cloudThinkParserClass;

// MResources Singleton--- static object
+(MResources *) getResources;


// Models
- (CloudThinkParserClass *) getCloudThinkParserClass;

@end

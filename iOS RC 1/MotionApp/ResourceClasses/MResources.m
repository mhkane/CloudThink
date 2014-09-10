//  MResources.m

#import "MResources.h"

@implementation MResources

static MResources *resources;

@synthesize cloudThinkParserClass;


/**
 Singleton instance of MResources - static object
 */
+ (MResources*) getResources{
	if(resources == nil || resources == NULL){
		resources = [[MResources alloc] init];
	}
	return resources;
}


// Models
- (CloudThinkParserClass *) getCloudThinkParserClass
{
    if(self.cloudThinkParserClass == nil || self.cloudThinkParserClass == NULL)
    {
        self.cloudThinkParserClass = [[CloudThinkParserClass alloc] init];
    }
    return self.cloudThinkParserClass;
}

@end

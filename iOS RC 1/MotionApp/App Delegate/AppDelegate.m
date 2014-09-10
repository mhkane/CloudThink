//
//  AppDelegate.m

#import "AppDelegate.h"
#import "RecordVC.h"
#import "ReviewItemCell.h"
#import "SettingsVC.h"
#import "ReviewVC.h"
#import "NetworkManager.h"

#define DATABASE_NAME	@"MotionApp.sqlite"
#define strDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define strResourcePath [[NSBundle mainBundle] resourcePath]

@implementation AppDelegate
{
    char                _networkOperationCountDummy;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self createDatabaseIfNeeded];
    
    [[NetworkManager sharedInstance] addObserver:self forKeyPath:@"networkOperationCount" options:NSKeyValueObservingOptionInitial context:&self->_networkOperationCountDummy];
    
    [self initializeTabBar];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        
//        self.window.clipsToBounds =YES;
//        
        self.window.frame =  CGRectMake(0,20,self.window.bounds.size.width,self.window.bounds.size.height-20);
    }
    [application setStatusBarHidden:NO];
    
    m_gAryCheckin = @[@"Walking", @"Bus", @"Running", @"Airplane", @"Cycling", @"Train", @"Driving", @"Boat", @"Stationary"];
    m_gIndexCheckin = -1;
    
    return YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &self->_networkOperationCountDummy) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = ([NetworkManager sharedInstance].networkOperationCount != 0);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)showNetworkActivity
{
    [self.window addSubview:self.networkActivityView];
    [self.window bringSubviewToFront:self.networkActivityView];
    [self.networkActivityView startActivity];
}


-(void) createDatabaseIfNeeded
{
	NSString* filePath = [NSString stringWithFormat:@"%@/%@", strDocumentPath, DATABASE_NAME];
    //NSLog(@"Checking file existance");
	if (![self checkExistanceOfFileAtPath:filePath])
    {
		//copy database
		NSString* sourcePath = [NSString stringWithFormat:@"%@/%@", strResourcePath, DATABASE_NAME];
		[self copyFileFromPath:sourcePath to:filePath];
        //NSLog(@"Copying file to internal memory");
	}
    else {
        //NSLog(@"File not copied");
    }
}


- (BOOL) checkExistanceOfFileAtPath:(NSString*) path
{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = NO;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
        //NSLog(@"File exists");
		return YES;
	}
    //NSLog(@"File DNE");
	return NO;
}

- (void) copyFileFromPath:(NSString*) fromFile to:(NSString*) toFile
{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	[NSFm copyItemAtPath:fromFile toPath:toFile error:nil];
}


- (void)hideNetworkActivity
{
    [self.networkActivityView stopActivity];
}


#pragma UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *myNavController = (UINavigationController *)viewController;
    
    [myNavController popToRootViewControllerAnimated:NO];
}


- (void)initializeTabBar
{
    UINavigationController * recordNavController;
    UINavigationController * reviewNavController;
    UINavigationController * settingsNavControllr;
    
    RecordVC * objRecordVC;
    ReviewVC * objReviewVC;
    SettingsVC * objSettingsVC;
    
    objRecordVC = [[RecordVC alloc]initWithNibName:@"RecordVC_5" bundle:nil];
    
    objReviewVC = [[ReviewVC alloc]initWithNibName:@"ReviewVC_5" bundle:nil];
    
    objSettingsVC = [[SettingsVC alloc]initWithNibName:@"SettingsVC_5" bundle:nil];
    
    
    
    recordNavController = [[UINavigationController alloc] initWithRootViewController:objRecordVC];
    [recordNavController setNavigationBarHidden:YES];
    
    reviewNavController = [[UINavigationController alloc] initWithRootViewController:objReviewVC];
    [reviewNavController setNavigationBarHidden:YES];
    
    settingsNavControllr =[[UINavigationController alloc]initWithRootViewController:objSettingsVC];
    [settingsNavControllr setNavigationBarHidden:YES];
    
    NSArray *tabbarviewcontroller = [NSArray arrayWithObjects:recordNavController, reviewNavController, settingsNavControllr,nil];
    
    self.tabBarController = [[CustomTabBarController alloc] init];
    self.tabBarController.viewControllers = tabbarviewcontroller;
    
    
    if ([[self.tabBarController.tabBar.items objectAtIndex:0] respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)])
    {
        [[self.tabBarController.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"logIcon_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"logIcon.png"]];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:@"Record"];
        
        [[self.tabBarController.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"reviewIcon_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"reviewIcon.png"]];
        [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Review"];

        [[self.tabBarController.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"settings2Icon_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings2Icon.png"]];
        [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Settings"];

        }
    
    [self.tabBarController setDelegate:self];
    
    // Override point for customization after application launch.
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}


- (BOOL)isIphone5
{
    BOOL value = YES;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960) {
                //NSLog(@"iPhone 4 Resolution");
                value = NO;
            }
            if(result.height == 1136) {
                //NSLog(@"iPhone 5 Resolution");
                value = YES;
            }
        }
        else{
            //NSLog(@"Standard Resolution");
        }
    }
    return value;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

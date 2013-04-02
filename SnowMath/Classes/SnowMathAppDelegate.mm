//
//  SnowMathAppDelegate.m
//  SnowMath
//
//  Created by ananda on 3/18/11.
//  Copyright 2011 香川高専（宅間）. All rights reserved.
//

#import "SnowMathAppDelegate.h"
#import "EAGLView.h"

#define IMAGE_COUNT       2
#define	IMAGE_WIDTH       380
#define IMAGE_HEIGHT      420
#define STATUS_BAR_HEIGHT 20
#define SCREEN_HEIGHT     460
#define SCREEN_WIDTH      320


@implementation SnowMathAppDelegate

@synthesize window;
@synthesize glView;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
  /*  // Override point for customization after application launch.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Array to hold jpg images
	imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
	
	// Build array of images, cycling through image names
	for (int i = 0; i < IMAGE_COUNT; i++)
		[imageArray addObject:[UIImage imageNamed:
							   [NSString stringWithFormat:@"snowBackground_%de.png", i]]];
	
	// Animated images - centered on screen
	animatedImages = [[UIImageView alloc] 
					  initWithFrame:CGRectMake(
											   (SCREEN_WIDTH / 2) - (IMAGE_WIDTH / 2), 
											   (SCREEN_HEIGHT / 2) - (IMAGE_HEIGHT / 2) + STATUS_BAR_HEIGHT,
											   IMAGE_WIDTH, IMAGE_HEIGHT)];
	animatedImages.animationImages = [NSArray arrayWithArray:imageArray];
	
	// One cycle through all the images takes 1 seconds
	animatedImages.animationDuration = 1.0;
	
	// Repeat forever
	animatedImages.animationRepeatCount = 0;
	
	// Add subview and make window visible
	[window addSubview:animatedImages];
	[window makeKeyAndVisible];
	
	// Start it up
	animatedImages.startAnimating;
	
	// Wait 5 seconds, then stop animation
	[self performSelector:@selector(stopAnimation) withObject:nil afterDelay:5];
	
	*/
    [self.window makeKeyAndVisible];	
    [glView startAnimation];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[glView stopAnimation];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[glView stopAnimation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[glView startAnimation];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[glView stopAnimation];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[imageArray release];
	[animatedImages release];
    [window release];
	[glView release];
    [super dealloc];
}


@end

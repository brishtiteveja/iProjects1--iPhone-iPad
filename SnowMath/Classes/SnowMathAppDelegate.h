//
//  SnowMathAppDelegate.h
//  SnowMath
//
//  Created by ananda on 3/18/11.
//  Copyright 2011 香川高専（宅間）. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface SnowMathAppDelegate : NSObject <UIApplicationDelegate> {
    UIImageView *animatedImages;
	NSMutableArray *imageArray;
	UIWindow *window;
	EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end


//
//  EAGLView.h
//  glTest
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ES1Renderer.h"

@class ES1Renderer;
// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.


@interface EAGLView : UIView
{    
@private
	ES1Renderer* renderer;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	// Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id displayLink;
    NSTimer *animationTimer;
	UIButton *playB,*helpB,*zeroB,*oneB,*twoB,*threeB,*fourB,*fiveB,*sixB,*sevenB,*eightB,*nineB,*equalB;
	bool touch0,touch1,touch2,touch3,touch4,touch5,touch6,touch7,touch8,touch9;
	int howManyPresses;
@public	
	bool ballSelection;
	int selBallIndex;
	int pressOrder[3];
	
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void) startAnimation;
- (void) stopAnimation;
- (void) drawView:(id)sender;
- (void) hidePlayButton;
- (void) showPlayButton;
- (void) playGame:(id)sender;
- (void) hideHelpButton;
- (void) showHelpButton;
- (void) showNumberButton;
- (void) hideNumberButton;
- (void) helpInfo:(id)sender;
- (void) pressZero:(id)sender;
- (void) pressOne:(id)sender;
- (void) pressTwo:(id)sender;
- (void) pressThree:(id)sender;
- (void) pressFour:(id)sender;
- (void) pressFive:(id)sender;
- (void) pressSix:(id)sender;
- (void) pressSeven:(id)sender;
- (void) pressEight:(id)sender;
- (void) pressNine:(id)sender;
- (void) pressEqual:(id)sender;
- (void) retrieveNormal;

@end

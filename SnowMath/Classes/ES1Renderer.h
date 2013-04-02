//
//  ES1Renderer.h
//  glTest
//

#import "EAGLView.h"
#import "ESRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AVFoundation/AVFoundation.h>
#import "graphicUtil.h"
#import "SnowBall.h"
#import "genNumOp.h"
#include <cmath>



@class EAGLView;

@interface ES1Renderer : NSObject <ESRenderer>
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	//Logo
	GLuint logo;
	//テクスチャを管理するためのID
	GLuint backgroundTexture1;
	GLuint backgroundTexture2;
	GLuint numberTexture;	//数字用のテクスチャ

	//sound
	AVAudioPlayer *bgSnowFallSound;

	
	//timer for animated image
	NSDate* timer;
	
	//access to EAGLView
	EAGLView* glView;
	
@public		
	int BALL_NUM,snowFallNo;
	
	//score
	int score;
	
	bool bgSoundFlag,ballVanishSoundFlag;
	
	//creating instance of snowball class
	SnowBall** ball;
	SnowBall** snowfall;
	
	//creating instance of number class
	genNumOp** numOp;
	
	//ballvanish sound
	AVAudioPlayer *ballVanishSound;
	

	

@public
	BOOL playTime;
	int *realAns;
	int **realAnsDigit;
}

@property(nonatomic , assign)EAGLView* glView;

- (void) render;
- (void) renderMain;	//描画のメインとなる部分をこの関数に記述していきます
- (void) startNewGame; //starting a new game
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;
- (void) touchedAtX:(float)x andY:(float)y;
- (void) calcVariationwithballIndex:(int)ballIndex;
- (void) drawCalc:(int)i;
- (void) digitCalc:(int)ballIndex;
- (void) checkAnswer:(int)i;


@end

//
//  EAGLView.m
//  glTest
//

#import "EAGLView.h"

#import "ES1Renderer.h"

@implementation EAGLView
@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id) initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
			renderer = [[ES1Renderer alloc] init];
			
			if (!renderer)
			{
				[self release];
				return nil;
			}
        //referencing EAGLView from ES1renderer
		renderer.glView = self;
		
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
		
		//no press yet
		howManyPresses = 0;
		//no selected balls
		ballSelection = false;
		selBallIndex = -1;
		
		//initializing pressOrder values
		pressOrder[0] = pressOrder[1] = pressOrder[2] = -1;	
		
		//User interface		
		playB = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, 170.0f, 100.0f, 50.0f)];
		[playB setBackgroundImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[playB addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:playB];
		
		helpB = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, 240.0f, 100.0f, 50.0f)];
		[helpB setBackgroundImage:[UIImage imageNamed:@"helpButton.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[helpB addTarget:self action:@selector(helpInfo:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:helpB];
		
		touch0 = touch1 = touch2 = touch3 = touch4 = touch5 = touch6 = touch7 = touch8 = touch9 = false;
		
		zeroB = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 410.0f, 50.0f, 50.0f)];
		[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[zeroB addTarget:self action:@selector(pressZero:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:zeroB];
		oneB = [[UIButton alloc]initWithFrame:CGRectMake(30.0f, 360.0f, 50.0f, 50.0f)];
		[oneB setBackgroundImage:[UIImage imageNamed:@"button_1.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[oneB addTarget:self action:@selector(pressOne:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:oneB];
		twoB = [[UIButton alloc]initWithFrame:CGRectMake(56.0f, 415.0f, 50.0f, 50.0f)];
		[twoB setBackgroundImage:[UIImage imageNamed:@"button_2.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[twoB addTarget:self action:@selector(pressTwo:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:twoB];
		threeB = [[UIButton alloc]initWithFrame:CGRectMake(93.0f, 360.0f, 50.0f, 50.0f)];
		[threeB setBackgroundImage:[UIImage imageNamed:@"button_3.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[threeB addTarget:self action:@selector(pressThree:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:threeB];
		fourB = [[UIButton alloc]initWithFrame:CGRectMake(110.0f, 410.0f, 50.0f, 50.0f)];
		[fourB setBackgroundImage:[UIImage imageNamed:@"button_4.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[fourB addTarget:self action:@selector(pressFour:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:fourB];
		fiveB = [[UIButton alloc]initWithFrame:CGRectMake(165.0f, 366.0f, 50.0f, 50.0f)];
		[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[fiveB addTarget:self action:@selector(pressFive:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:fiveB];
		sixB = [[UIButton alloc]initWithFrame:CGRectMake(164.0f, 420.0f, 50.0f, 50.0f)];
		[sixB setBackgroundImage:[UIImage imageNamed:@"button_6.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[sixB addTarget:self action:@selector(pressSix:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:sixB];
		sevenB = [[UIButton alloc]initWithFrame:CGRectMake(220.0f, 358.0f, 50.0f, 50.0f)];
		[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[sevenB addTarget:self action:@selector(pressSeven:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:sevenB];
		eightB = [[UIButton alloc]initWithFrame:CGRectMake(215.0f, 410.0f, 50.0f, 50.0f)];
		[eightB setBackgroundImage:[UIImage imageNamed:@"button_8.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[eightB addTarget:self action:@selector(pressEight:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:eightB];
		nineB = [[UIButton alloc]initWithFrame:CGRectMake(270.0f, 345.0f, 50.0f, 50.0f)];
		[nineB setBackgroundImage:[UIImage imageNamed:@"button_9.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[nineB addTarget:self action:@selector(pressNine:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:nineB];
		equalB= [[UIButton alloc]initWithFrame:CGRectMake(265.0f, 410.0f, 50.0f, 50.0f)];
		[equalB setBackgroundImage:[UIImage imageNamed:@"button_equal.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[equalB addTarget:self action:@selector(pressEqual:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:equalB];
		
    }
	
    return self;
}

- (void) drawView:(id)sender
{
    [renderer render];
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.

			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}
- (void) showPlayButton
{
	[playB setHidden :FALSE];
}

- (void) hidePlayButton
{
	[playB setHidden:TRUE];
}

- (void) showNumberButton
{
	[zeroB setHidden:FALSE];
	[oneB setHidden:FALSE];
	[twoB setHidden:FALSE];
	[threeB setHidden:FALSE];
	[fourB setHidden:FALSE];
	[fiveB setHidden:FALSE];
	[sixB setHidden:FALSE];
	[sevenB setHidden:FALSE];
	[eightB setHidden:FALSE];
	[nineB setHidden:FALSE];
	[equalB setHidden:FALSE];
}

- (void) hideNumberButton
{
	[zeroB setHidden:TRUE];
	[oneB setHidden:TRUE];
	[twoB setHidden:TRUE];
	[threeB setHidden:TRUE];
	[fourB setHidden:TRUE];
	[fiveB setHidden:TRUE];
	[sixB setHidden:TRUE];
	[sevenB setHidden:TRUE];
	[eightB setHidden:TRUE];
	[nineB setHidden:TRUE];
	[equalB setHidden:TRUE];
}
- (void) playGame:(id)sender {
	renderer ->playTime=TRUE;// using ES1renderer's public variable for playTime flag
    [renderer startNewGame];
}
- (void) showHelpButton
{
	[helpB setHidden:FALSE];
}

- (void) pressZero:(id)sender
{	
	/*int rAns;
	for (int i = 0; i < renderer->BALL_NUM; i++) {
		rAns = renderer->realAns[i];
		NSLog(@"answer = %d\n",rAns);
		for (int k = 0; k < renderer->numOp[i]->digitCount(rAns); k++) {
			NSLog(@"answerdigit[%d] = %d  ",k,renderer->realAnsDigit[i][k]);
		}		
	}*/
	
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 0) {
				[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:zeroB];
				touch0 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 0){
			if(touch0 == true){
				if (howManyPresses == 1) {
					[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:zeroB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:zeroB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch0 = true;
			}

		}
	}
	
	/*if(howManyPresses < max){
		NSLog(@"howmanyPresses = %d \n",howManyPresses);
	
		if (touch0 == false) {
			[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:zeroB];
			touch0 = true;
			howManyPresses++;
		}else {
			[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:zeroB];
			touch0 = false;
		}
	}else {
		if (touch0 == true) {
			[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:zeroB];
			touch0 = false;
			howManyPresses--;
		}

 
	}*/


	
}
- (void) pressOne:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 1) {
				[oneB setBackgroundImage:[UIImage imageNamed:@"button_1t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:oneB];
				touch1 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 1){
			if(touch1 == true){
				if (howManyPresses == 1) {
					[oneB setBackgroundImage:[UIImage imageNamed:@"button_1ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[oneB setBackgroundImage:[UIImage imageNamed:@"button_1tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:oneB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[oneB setBackgroundImage:[UIImage imageNamed:@"button_1t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:oneB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch1 = true;
			}
			
		}
	}
	/*
	int rAns = renderer->realAns[0],rAns2,cmax;
	int max = renderer->numOp[0]->digitCount(rAns);
	for (int i = 1; i < renderer->BALL_NUM; i++) {
		rAns2 = renderer->realAns[i];
		cmax = renderer->numOp[0]->digitCount(rAns2);
		if (cmax > max) {
			max = cmax ;
		}				
	}
	if(howManyPresses < max){
		NSLog(@"howmanyPresses = %d \n",howManyPresses);
		
		if (touch1 == false) {
			[oneB setBackgroundImage:[UIImage imageNamed:@"button_1t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:oneB];
			touch1 = true;
			howManyPresses++;
		}else {
			[oneB setBackgroundImage:[UIImage imageNamed:@"button_1.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:oneB];
			touch1 = false;
		}
	}else {
		if (touch1 == true) {
			[oneB setBackgroundImage:[UIImage imageNamed:@"button_1.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:oneB];
			touch1 = false;
			howManyPresses--;
		}
	}*/

}
- (void) pressTwo:(id)sender
{
	if(ballSelection == false){
	//	NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
	//		NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 2) {
				[twoB setBackgroundImage:[UIImage imageNamed:@"button_2t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:twoB];
				touch2 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 2){
			if(touch2 == true){
				if (howManyPresses == 1) {
					[twoB setBackgroundImage:[UIImage imageNamed:@"button_2ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[twoB setBackgroundImage:[UIImage imageNamed:@"button_2tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:twoB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[twoB setBackgroundImage:[UIImage imageNamed:@"button_2t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:twoB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch2 = true;
			}
			
		}
	}	
	/*int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 2) {
			[twoB setBackgroundImage:[UIImage imageNamed:@"button_2t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:twoB];
			touch2 = true;
			howManyPresses++;
		}				
	}
	if (touch2 == false) {
		[twoB setBackgroundImage:[UIImage imageNamed:@"button_2t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:twoB];
		touch2 = true ;
	}else {
		[twoB setBackgroundImage:[UIImage imageNamed:@"button_2.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:twoB];
		touch2 = false;
	}*/
}
- (void) pressThree:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 3) {
				[threeB setBackgroundImage:[UIImage imageNamed:@"button_3t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:threeB];
				touch3 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 3){
			if(touch3 == true){
				if (howManyPresses == 1) {
					[threeB setBackgroundImage:[UIImage imageNamed:@"button_3ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[threeB setBackgroundImage:[UIImage imageNamed:@"button_3tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:threeB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[threeB setBackgroundImage:[UIImage imageNamed:@"button_3t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:threeB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch3 = true;
			}
			
		}
	}	
	/*int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 3) {
			[threeB setBackgroundImage:[UIImage imageNamed:@"button_3t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:threeB];
			touch3 = true;
			howManyPresses++;
		}				
	}
	if (touch3 == false) {
		[threeB setBackgroundImage:[UIImage imageNamed:@"button_3t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:threeB];
		touch3 = true ;
	}else {
		[threeB setBackgroundImage:[UIImage imageNamed:@"button_3.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:threeB];
		touch3 = false;
	}*/
	
}
- (void) pressFour:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 4) {
				[fourB setBackgroundImage:[UIImage imageNamed:@"button_4t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:fourB];
				touch4 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 4){
			if(touch4 == true){
				if (howManyPresses == 1) {
					[fourB setBackgroundImage:[UIImage imageNamed:@"button_4ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[fourB setBackgroundImage:[UIImage imageNamed:@"button_4tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:fourB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[fourB setBackgroundImage:[UIImage imageNamed:@"button_4t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:fourB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch4 = true;
			}
			
		}
	}	
	/*if (touch4 == false) {
		[fourB setBackgroundImage:[UIImage imageNamed:@"button_4t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:fourB];
		touch4 = true ;
	}else {
		[fourB setBackgroundImage:[UIImage imageNamed:@"button_4.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:fourB];
		touch4 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 4) {
			[fourB setBackgroundImage:[UIImage imageNamed:@"button_4t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:fourB];
			touch4 = true;
			howManyPresses++;
		}				
	}*/
}
- (void) pressFive:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 5) {
				[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:fiveB];
				touch5 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 5){
			if(touch5 == true){
				if (howManyPresses == 1) {
					[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:fiveB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:fiveB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch5 = true;
			}
			
		}
	}		
	/*if (touch5 == false) {
		[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:fiveB];
		touch5 = true ;
	}else {
		[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:fiveB];
		touch5 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 5) {
			[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:fiveB];
			touch5 = true;
			howManyPresses++;
		}				
	}*/
}
- (void) pressSix:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 6) {
				[sixB setBackgroundImage:[UIImage imageNamed:@"button_6t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:sixB];
				touch6 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 6){
			if(touch6 == true){
				if (howManyPresses == 1) {
					[sixB setBackgroundImage:[UIImage imageNamed:@"button_6ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[sixB setBackgroundImage:[UIImage imageNamed:@"button_6tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:sixB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[sixB setBackgroundImage:[UIImage imageNamed:@"button_6t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:sixB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch6 = true;
			}
			
		}
	}		
	/*if (touch6 == false) {
		[sixB setBackgroundImage:[UIImage imageNamed:@"button_6t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:sixB];
		touch6 = true ;
	}else {
		[sixB setBackgroundImage:[UIImage imageNamed:@"button_6.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:sixB];
		touch6 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 6) {
			[sixB setBackgroundImage:[UIImage imageNamed:@"button_6t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:sixB];
			touch6 = true;
			howManyPresses++;
		}				
	}*/
}
- (void) pressSeven:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
			//NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 7) {
				[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:sevenB];
				touch7 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 7){
			if(touch7 == true){
				if (howManyPresses == 1) {
					[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:sevenB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:sevenB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch7 = true;
			}
			
		}
	}		
	/*if (touch7 == false) {
		[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:sevenB];
		touch7 = true ;
	}else {
		[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:sevenB];
		touch7 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 7) {
			[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:sevenB];
			touch7 = true;
			howManyPresses++;
		}				
	}*/
}
- (void) pressEight:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
			//NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 8) {
				[eightB setBackgroundImage:[UIImage imageNamed:@"button_8t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:eightB];
				touch8 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 8){
			if(touch8 == true){
				if (howManyPresses == 1) {
					[eightB setBackgroundImage:[UIImage imageNamed:@"button_8ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[eightB setBackgroundImage:[UIImage imageNamed:@"button_8tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:eightB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[eightB setBackgroundImage:[UIImage imageNamed:@"button_8t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:eightB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch8 = true;
			}
			
		}
	}		
	/*if (touch8 == false) {
		[eightB setBackgroundImage:[UIImage imageNamed:@"button_8t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:eightB];
		touch8 = true ;
	}else {
		[eightB setBackgroundImage:[UIImage imageNamed:@"button_8.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:eightB];
		touch8 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 8) {
			[eightB setBackgroundImage:[UIImage imageNamed:@"button_8t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:eightB];
			touch8 = true;
			howManyPresses++;
		}				
	}*/
}
- (void) pressNine:(id)sender
{
	if(ballSelection == false){
		//NSLog(@"selBallIndex = %d\n",selBallIndex);
		int count = 0,i;
		for (((selBallIndex + 1) < renderer->BALL_NUM)? (i = selBallIndex + 1) : (i = 0); count < renderer->BALL_NUM; i++,count++) {
		//	NSLog(@"i = %d\n",i);
			if (i == renderer->BALL_NUM) {
				i = 0;
			}
			if (renderer->realAnsDigit[i][howManyPresses] == 9) {
				[nineB setBackgroundImage:[UIImage imageNamed:@"button_9t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:nineB];
				touch9 = true;
				pressOrder[howManyPresses] = renderer->realAnsDigit[i][howManyPresses];
				howManyPresses++;
				ballSelection = true;
				renderer->ball[i]->snowballTexture = loadTexture(@"snowballf3.png");
				selBallIndex = i;
				break;
			}	
		}
	}
	else if(ballSelection == true ){
		if(renderer->realAnsDigit[selBallIndex][howManyPresses] == 9){
			if(touch9 == true){
				if (howManyPresses == 1) {
					[nineB setBackgroundImage:[UIImage imageNamed:@"button_9ttt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				else if(howManyPresses == 2) {
					[nineB setBackgroundImage:[UIImage imageNamed:@"button_9tt.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				}
				[self addSubview:nineB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
			}else {
				[nineB setBackgroundImage:[UIImage imageNamed:@"button_9t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
				[self addSubview:nineB];
				if (howManyPresses  <= 2) {
					pressOrder[howManyPresses] = renderer->realAnsDigit[selBallIndex][howManyPresses];
					howManyPresses++;
				}
				touch9 = true;
			}
			
		}
	}		
	/*if (touch9 == false) {
		[nineB setBackgroundImage:[UIImage imageNamed:@"button_9t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:nineB];
		touch9 = true ;
	}else {
		[nineB setBackgroundImage:[UIImage imageNamed:@"button_9.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
		[self addSubview:nineB];
		touch9 = false;
	}
	int k = howManyPresses;
	for (int i =0; i < renderer->BALL_NUM; i++) {
		if (renderer->realAnsDigit[i][k] == 9) {
			[nineB setBackgroundImage:[UIImage imageNamed:@"button_9t.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
			[self addSubview:nineB];
			touch9 = true;
			howManyPresses++;
		}				
	}*/
}
-(void) pressEqual:(id)sender
{
	//int actualAns;
	//int userAns;
	
	//if () {
	//	
	//}
	if(howManyPresses != 0){
	 int rAns,rAnsdigitNo,k;
		
	 
	  rAns = renderer->realAns[selBallIndex];
	  rAnsdigitNo = floor( log10( abs( rAns != 0 ? rAns: 1 ) ) ) + 1;
	  
	  NSLog(@"num1 = %d \n num2 = %d \n operator = %d \n answer = %d\n",renderer->numOp[selBallIndex]->num1,renderer->numOp[selBallIndex]->num2,renderer->numOp[selBallIndex]->op, rAns);
	 
	  for (k = 0; k < rAnsdigitNo ; k++) {
		 //	NSLog(@"answerdigit[%d] = %d  ",k,renderer->realAnsDigit[i][k]);
		  if(pressOrder[k] != renderer->realAnsDigit[selBallIndex][k])
			  break;
	  }		
	 
	 
	//  NSLog(@"howmanypresses = %d  k = %d \n",howManyPresses,k);
	  //renderer->numOp[selBallIndex]->digitCount(rAns)
	  if ( howManyPresses == k && k == rAnsdigitNo) {
		  if (renderer->ballVanishSoundFlag) {
			  [renderer->ballVanishSound setCurrentTime:arc4random() % 2 * 1.0f ] ;
			  [renderer->ballVanishSound play] ; 
		  }
		 
		  renderer->score += 50;
		  NSLog(@"Equation Solved = %d  Total Score = %d \n",renderer->score / 50,renderer->score);
		  renderer->ball[selBallIndex]->ballSpeed = 0.15f;
		  ballSelection = false;
	  }
	  //renderer->ball[selBallIndex]->snowballTexture = loadTexture(@"snowballf.png");
 }

}
- (void) retrieveNormal{
	//retrieve into the normal mode
	[zeroB setBackgroundImage:[UIImage imageNamed:@"button_0.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:zeroB];
	
	[oneB setBackgroundImage:[UIImage imageNamed:@"button_1.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	[self addSubview:oneB];
	
	[twoB setBackgroundImage:[UIImage imageNamed:@"button_2.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:twoB];
	
	[threeB setBackgroundImage:[UIImage imageNamed:@"button_3.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:threeB];
	
	[fourB setBackgroundImage:[UIImage imageNamed:@"button_4.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:fourB];
	
	[fiveB setBackgroundImage:[UIImage imageNamed:@"button_5.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:fiveB];
	
	[sixB setBackgroundImage:[UIImage imageNamed:@"button_6.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:sixB];
	
	[sevenB setBackgroundImage:[UIImage imageNamed:@"button_7.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:sevenB];
	
	[eightB setBackgroundImage:[UIImage imageNamed:@"button_8.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:eightB];
	
	[nineB setBackgroundImage:[UIImage imageNamed:@"button_9.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:nineB];
	
	[equalB setBackgroundImage:[UIImage imageNamed:@"button_equal.png"] forState:UIControlStateNormal & UIControlStateHighlighted];
	
	[self addSubview:equalB];
	
	howManyPresses = 0;
	touch0 = touch1 = touch2 = touch3 = touch4 = touch5 = touch6 = touch7 = touch8 = touch9 = false;

}


- (void) hideHelpButton
{
	[helpB setHidden:TRUE];
}
- (void) helpInfo:(id)sender {

}

//touch began
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [touches anyObject];
	
	CGPoint pt = [touch locationInView:self];
	
	float glX = (pt.x / 320.0f) * 2.0f -1.0f ;
	float glY = (pt.y / 480.0f) * 3.0f +1.5f ;
	
	[renderer touchedAtX:glX andY:glY];
}



- (void) dealloc
{
    [renderer release];
	
    [super dealloc];
}

@end

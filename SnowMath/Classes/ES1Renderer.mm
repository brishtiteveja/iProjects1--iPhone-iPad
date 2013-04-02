//
//  ES1Renderer.m
//  glTest
//

#import "ES1Renderer.h"
#import "graphicUtil.h"

#define randF() ((float)(rand() % 1001 * 0.001f))
#define animationTimeInterval 2

@implementation ES1Renderer
@synthesize glView;

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
		
		srand(time(nil));
		
		//画像ファイルを読み込んでテクスチャを生成します
		logo = loadTexture(@"ABStudio-vivid.png");
		//logo = loadTexture(@"ABstudio.png");
		backgroundTexture1 = loadTexture(@"snowBackground_1e.png");
		backgroundTexture2 = loadTexture(@"snowBackground_2e.png");
		numberTexture = loadTexture(@"numberTexture.png");
		/*
		 if(backgroundTexture1 != 0 && backgroundTexture2 != 0){
			NSLog(@"Textureを生成しました!");
		}*/
		
		
		bgSoundFlag = true;
		ballVanishSoundFlag = true;
		
		//loading background sound file
		NSString *bgSnowFallSoundPath = [[NSBundle mainBundle]pathForResource:@"wind-chime-long" ofType:@"wav"];
		NSURL *bgSnowFallSoundUrl = [NSURL fileURLWithPath: bgSnowFallSoundPath];
		bgSnowFallSound = [[AVAudioPlayer alloc] initWithContentsOfURL:bgSnowFallSoundUrl error:nil];
		[bgSnowFallSound setNumberOfLoops:-1];
		
		//loading ball vanish sound file
		NSString *ballVanishSoundPath = [[NSBundle mainBundle]pathForResource:@"dream-harp" ofType:@"wav"];
		NSURL *ballVanishSoundUrl = [NSURL fileURLWithPath: ballVanishSoundPath];
		ballVanishSound = [[AVAudioPlayer alloc] initWithContentsOfURL:ballVanishSoundUrl error:nil];
		[ballVanishSound prepareToPlay];

				
		timer=[[NSDate date]retain];//recording starting time 

	}
	
	return self;
}

- (void) calcVariationwithballIndex:(int)ballIndex
{	
	numOp[ballIndex] = new genNumOp();
    [self digitCalc: ballIndex];
	
/*	
	if (numOp[ballIndex]->op == 10) {
		numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 + numOp[ballIndex]->num2;
	}else if (numOp[ballIndex]->op == 11) {
		numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 - numOp[ballIndex]->num2;
	}else if (numOp[ballIndex]->op == 12) {
		numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 * numOp[ballIndex]->num2;
	}else if (numOp[ballIndex]->op == 13) {
		numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 / numOp[ballIndex]->num2 ;
	}
	
	int count = 0,noEntry = 0;
	
	for (int i = 0 ; count < 5 || noEntry == (BALL_NUM - 1) ;count++ , i++) {
		
		if (i == ballIndex) {
			continue;
		}
		
		if (numOp[ballIndex]->nowAns == numOp[i]->nowAns) {
					
			numOp[ballIndex] = new genNumOp();

				
				
			if (numOp[ballIndex]->op == 10) {
				numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 + numOp[ballIndex]->num2;
			}else if (numOp[ballIndex]->op == 11) {
				numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 - numOp[ballIndex]->num2;
			}else if (numOp[ballIndex]->op == 12) {
				numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 * numOp[ballIndex]->num2;
			}else if (numOp[ballIndex]->op == 13) {
				numOp[ballIndex]->nowAns = numOp[ballIndex]->num1 / numOp[ballIndex]->num2 ;
			}
			
			i = -1;
			noEntry = 0;
		}
		else{
			noEntry++;
		}
		
		
	}
 */

		
}
- (void) digitCalc: (int)ballIndex {
	//find digitDensity and determining digits
	numOp[ballIndex]->digNum1 = numOp[ballIndex]->digitCount(numOp[ballIndex]->num1);
	
	numOp[ballIndex]->digNum2 = numOp[ballIndex]->digitCount(numOp[ballIndex]->num2);
	
	if (numOp[ballIndex]->digNum1 == 1 && numOp[ballIndex]->digNum2 == 1) {
		numOp[ballIndex]->digitDensity = 0;
	}else if (numOp[ballIndex]->digNum1 == 2 && numOp[ballIndex]->digNum2 == 2) {
		numOp[ballIndex]->digitDensity = 1;
	}else if (numOp[ballIndex]->digNum1 == 2 && numOp[ballIndex]->digNum2 == 1) {
		numOp[ballIndex]->digitDensity = 2;
	}else if (numOp[ballIndex]->digNum1 == 1 && numOp[ballIndex]->digNum2 == 2) {
		numOp[ballIndex]->digitDensity = 3;
	}
	
	
	int dividend = numOp[ballIndex]->num1,divisor = 10;
	
	if (numOp[ballIndex]->digNum1 == 1) {
		if (numOp[ballIndex]->digitDensity == 0) {
			numOp[ballIndex]->upNum1 = numOp[ballIndex]->num1;
		}else if (numOp[ballIndex]->digitDensity == 3) {
			numOp[ballIndex]->upNum2 = numOp[ballIndex]->num1;
		}
	}
	else if(numOp[ballIndex]->digNum1 == 2){
		numOp[ballIndex]->upNum2 = dividend % divisor;
		
		dividend = dividend / divisor;
		
		numOp[ballIndex]->upNum1 = dividend % divisor;
	}
	
	dividend = numOp[ballIndex]->num2;
	
	if (numOp[ballIndex]->digNum2 == 1) {
		if (numOp[ballIndex]->digitDensity == 0) {
			numOp[ballIndex]->downNum1 = numOp[ballIndex]->num2;
		}else if (numOp[ballIndex]->digitDensity == 2) {
			numOp[ballIndex]->downNum2 = numOp[ballIndex]->num2;
		}
	}
	else if(numOp[ballIndex]->digNum2 == 2){
		numOp[ballIndex]->downNum2 = dividend % divisor;
		
		dividend = dividend / divisor;
		
		numOp[ballIndex]->downNum1 = dividend % divisor;
	}
	
}


- (void) render
{
    // Replace the implementation of this method to do your own custom drawing
	
	// This application only creates a single context which is already set current at this point.
	// This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
    
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, 0.5f, -0.5f);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	
	int passedTime=(int)floor(-[timer timeIntervalSinceNow]);
	
	if (passedTime >= 4) {
			[glView showPlayButton];
			[glView showHelpButton];
			[glView hideNumberButton];
			if (bgSoundFlag == true) {
				[bgSnowFallSound play];	
			}

			[self renderMain];	//ポリゴン等を描画します
	}else {
		drawTexture(0.0f, 0.0f, 2.6f, 3.8f, logo, 255, 255, 255, 255);
		//drawTexture(0.0f, 0.0f, 2.7f, 4.0f, logo, 255, 255, 255, 255);
		[glView hidePlayButton];
		[glView hideHelpButton];
		[glView hideNumberButton];
		if (passedTime == 1) 
		 {
				
			playTime = FALSE ;
			BALL_NUM = 3;
			snowFallNo = 200; 
			score = 0 ; 
			//arc4random()%100 + 150;
			
			ball = new SnowBall* [BALL_NUM];
			snowfall = new SnowBall* [snowFallNo];
			
			numOp = new genNumOp* [BALL_NUM];
			realAns = new int[BALL_NUM];
			realAnsDigit = new int* [BALL_NUM];
			
			for (int p = 0; p < BALL_NUM; p++) {
				realAnsDigit[p] = new int[3];
			}
			
			//snowfall animation
			for (int i = 0; i < snowFallNo; i++ ) {
				
				float x = randF() * 4.0f - 3.0f;
				float y = randF() * 4.0f - 1.0f;
				
				float angle = (float)(rand() % 360);
				
				float size = arc4random() % 9 * 0.004f ;
				
				float speed = (rand()%9)*0.001f + 0.006f;
				//randF() * 0.01f + 0.01f;
				
				float turnAngle = randF() * 4.0f - 2.0f;
				
				snowfall[i] = new SnowBall(i,x,y,angle,size,speed,turnAngle,loadTexture(@"snowballf2.png"));				
				
			}
			
			for (int i = 0; i < BALL_NUM; i++ ) {
				
				float x = randF() * 2.0f - 1.0f;
				float y = 1.65f;
				
				float angle = (float)(rand() % 360);
				
				float size = randF() * 0.25f + 0.25f;
				
				float speed = (rand()%4)*0.001f + 0.005f;
				//randF() * 0.01f + 0.01f;
				
				float turnAngle = randF() * 4.0f - 2.0f;
				
				ball[i] = new SnowBall(i,x,y,angle,size,speed,turnAngle,loadTexture(@"snowballf2.png"));
				
				//determining different variation of calculation,finding progress,applying algorithms
				[self calcVariationwithballIndex : i];			
				
			}
		}
	}


    
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

//描画のメインとなる部分をこの関数に記述していきます
- (void) renderMain{
	//passed time for animating background image
//	int passedTime=(int)floor(-[timer timeIntervalSinceNow]);
	//NSLog(@"passed time:%d",passedTime);
	
//	int remainTime = passedTime % 2 ;
	
	//座標と縦横幅を数値で指定してテクスチャを描画します
//	if(remainTime == 0 || remainTime == 2)
	
	
	
	drawTexture(0.0f, 0.0f, 2.0f, 3.0f, backgroundTexture1, 255, 255, 255, 255);
	for (int i = 0; i < snowFallNo; i++) {
		
		//	if((int)randF() % 100 == 0)
		snowfall[i]->ballTurnAngle = randF() * 4.0f - 2.0f;
		
		
		snowfall[i]->ballAngle = snowfall[i]->ballAngle + snowfall[i]->ballTurnAngle ;
		
		snowfall[i]->ballMove();
		
		snowfall[i]->balldoWarp();
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		drawTexture(snowfall[i]->ballX - 0.01f, snowfall[i]->ballY - 0.10f, snowfall[i]->ballSize, snowfall[i]->ballSize, snowfall[i]->snowballTexture, 255, 255, 255, 255);
		glDisable(GL_BLEND);
		
	}
 
	
	/*	else if(remainTime ==1) {
		drawTexture(0.0f, 0.0f, 2.0f, 3.0f, backgroundTexture2, 255, 255, 255, 255);
	}
 */
	
	if (!playTime) {
		[glView showPlayButton];
		[glView showHelpButton];
		[glView hideNumberButton];
	}
	else {
		[self startNewGame];

	}

	
}

- (void) startNewGame
{
	[glView	hidePlayButton];
	[glView hideHelpButton];
	[glView showNumberButton];
	

	//passed time for animating background image
	int passedTime=(int)floor(-[timer timeIntervalSinceNow]);
	//NSLog(@"passed time:%d",passedTime);
	

	int remainTime = passedTime % 2 ;
	
	//座標と縦横幅を数値で指定してテクスチャを描画します
	if(remainTime == 0 || remainTime == 2)
		drawTexture(0.0f, 0.0f, 2.0f, 3.0f, backgroundTexture1, 255, 255, 255, 255);
	else if(remainTime ==1) {
		drawTexture(0.0f, 0.0f, 2.0f, 3.0f, backgroundTexture2, 255, 255, 255, 255);
	}
	
	for (int i = 0; i < snowFallNo; i++) {
		
		//	if((int)randF() % 100 == 0)
		snowfall[i]->ballTurnAngle = randF() * 4.0f - 2.0f;
		
		
		snowfall[i]->ballAngle = snowfall[i]->ballAngle + snowfall[i]->ballTurnAngle ;
		
		snowfall[i]->ballMove();
		
		snowfall[i]->balldoWarpSnow();
		
		glEnable(GL_BLEND);
	    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	    drawTexture(snowfall[i]->ballX - 0.01f, snowfall[i]->ballY - 0.10f, snowfall[i]->ballSize, snowfall[i]->ballSize, snowfall[i]->snowballTexture, 255, 255, 255, 255);
	    glDisable(GL_BLEND);
		
	}
	
	for (int i = 0; i < BALL_NUM; i++) {
		[self checkAnswer: i];
		
		//checking similar first digit answer balls and regenerating
		 int noEntry = 0;
		 
		 for (int j = 0 ; ;j++) {
		 
			 if (j == i) {
				 continue;
			 }
		 
			 if (i!= glView->selBallIndex && realAnsDigit[i][0] == realAnsDigit[j][0]) {
		 
				 numOp[i] = new genNumOp();
				 [self digitCalc: i];
				 [self checkAnswer: i];
		 
				 j = -1;
				 noEntry = 0;
			 }
			 else{
				 noEntry++;
			 }
		    if (noEntry == (BALL_NUM - 1)) {
				break;
			} 
		 
		 }
		
		//moving the balls
		if((int)randF() % 100 == 0){
		     ball[i]->ballTurnAngle = randF() * 4.0f - 2.0f;
		}
	
		ball[i]->ballAngle = ball[i]->ballAngle + ball[i]->ballTurnAngle ;

		ball[i]->ballMove();
	
		ball[i]->balldoWarp();
		 
	
		if (ball[i]->falldown == true) {
			//NSLog(@"selBallIndex = %d \n",glView->selBallIndex);
			//je junbane button gulo chapa hoyesilo seta jodi onno uttorer sathe match na kore sekhetre call korbo
		 if(glView->selBallIndex >= 0)
			if(ball[glView->selBallIndex]->falldown == true){
				[glView retrieveNormal]; //buttons and selected balls become normal
				glView->ballSelection = false;
				ball[glView->selBallIndex]->snowballTexture = loadTexture(@"snowballf2.png");
			}
			
			//reinitializing the speed and number of the ball fallen down
			
			ball[i]->ballSpeed = (rand()%2)*0.001f + 0.005f;
			
			ball[i]->falldown = false;
			//determining different variation of calculation,finding progress,applying algorithms
		    [self calcVariationwithballIndex : i];	
			
	
		}
	
		glEnable(GL_BLEND);
	    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	    drawTexture(ball[i]->ballX - 0.01f, ball[i]->ballY - 0.10f, 0.52f, 0.52f, ball[i]->snowballTexture, 255, 255, 255, 255);
		glDisable(GL_BLEND);
		[self drawCalc: i ];

	}
	
}
- (void)checkAnswer: (int)i{
	//checking answer
	if (numOp[i]->op == 10) {
		realAns[i] = numOp[i]->num1 + numOp[i]->num2;
	}else if (numOp[i]->op == 11) {
		realAns[i] = numOp[i]->num1 - numOp[i]->num2;
	}else if (numOp[i]->op == 12) {
		realAns[i] = numOp[i]->num1 * numOp[i]->num2;
	}else if (numOp[i]->op == 13) {
		realAns[i] = numOp[i]->num1 / numOp[i]->num2;
	}
	
	int dividend = realAns[i],divisor = 10;
	int k = numOp[i]->digitCount(realAns[i]) -1;
	
	
	while (k >= 0) {
		realAnsDigit[i][k] = dividend % divisor;
		if(dividend / divisor == 0)
			break;
		dividend = dividend / divisor;
		k--;
	}
}

- (void)drawCalc:(int)i{
	
	//NSLog(@"%d",numOp[i]->digitDensity);
	
	if (numOp[i]->digitDensity == 0) {
		
		//up first number 
		drawSymbol(ball[i]->ballX, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum1, numberTexture);
		
		//operator
		drawSymbol(ball[i]->ballX- 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->op, numberTexture);
		
		
		//down first number
		drawSymbol(ball[i]->ballX , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum1, numberTexture);
		
		//line below the numbers
		drawRectangle(ball[i]->ballX -0.0f , ball[i]->ballY - 0.24f, 0.40f, 0.01f, 0, 0, 0, 255);
			
	}
	else if(numOp[i]->digitDensity == 1){
			//up first number
			drawSymbol(ball[i]->ballX, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum1, numberTexture);
			
			//up second number 
			drawSymbol(ball[i]->ballX + 0.13f, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum2, numberTexture);
			
			//operator
			drawSymbol(ball[i]->ballX- 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->op, numberTexture);
			
			//down first number
			drawSymbol(ball[i]->ballX , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum1, numberTexture);
			
			//down second number
			drawSymbol(ball[i]->ballX + 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum2, numberTexture);
			
			//line below the numbers
			drawRectangle(ball[i]->ballX -0.0f , ball[i]->ballY - 0.24f, 0.40f, 0.01f, 0, 0, 0, 255);
		
		
		//	NSLog(@"answer = %d\n",realAns[i]);
	}
	else if(numOp[i]->digitDensity == 2){
		//up first number
		drawSymbol(ball[i]->ballX, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum1, numberTexture);
		
		//up second number 
		drawSymbol(ball[i]->ballX + 0.13f, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum2, numberTexture);
		
		//operator
		drawSymbol(ball[i]->ballX- 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->op, numberTexture);
		
		//down second number
		drawSymbol(ball[i]->ballX + 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum2, numberTexture);
		
		//line below the numbers
		drawRectangle(ball[i]->ballX -0.0f , ball[i]->ballY - 0.24f, 0.40f, 0.01f, 0, 0, 0, 255);
		
		
		//NSLog(@"answer = %d\n",realAns[i]);
	}
	else if(numOp[i]->digitDensity == 3){
		//up second number 
		drawSymbol(ball[i]->ballX + 0.13f, ball[i]->ballY, 0.125f, 0.125f, numOp[i]->upNum2, numberTexture);
		
		//operator
		drawSymbol(ball[i]->ballX- 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->op, numberTexture);
		
		//down first number
		drawSymbol(ball[i]->ballX , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum1, numberTexture);
		
		//down second number
		drawSymbol(ball[i]->ballX + 0.13f , ball[i]->ballY - 0.13f, 0.125f, 0.125f, numOp[i]->downNum2, numberTexture);
		
		//line below the numbers
		drawRectangle(ball[i]->ballX -0.0f , ball[i]->ballY - 0.24f, 0.40f, 0.01f, 0, 0, 0, 255);
		
		
	}

}



- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) touchedAtX:(float)x andY:(float)y{
	NSLog(@"%f,%f was touched",x,y);
}

- (void) dealloc
{
	NSLog(@"hello2");
	//テクスチャを解放します
	for (int i = 0; i < snowFallNo; i++) {
		if (snowfall[i]->snowballTexture) glDeleteTextures(1, &snowfall[i]->snowballTexture);
	}
	for (int i = 0; i < BALL_NUM; i++) {
		if (ball[i]->snowballTexture) glDeleteTextures(1, &ball[i]->snowballTexture);
	}
	
	//freeing ballnum,numop,realans
	//delete ball;
	for (int k = 0; k < BALL_NUM; k++) {
		delete[] ball[k];
		delete[] numOp[k];
	}
	delete[] ball;
	delete[] numOp;
	
	//snowfall
	for (int k = 0; k < snowFallNo; k++) {
		delete[] snowfall[k];
	}
	
	delete[] snowfall;
	
	
	delete[] realAns;
	for (int k = 0; k < BALL_NUM; k++) {
			delete[] realAnsDigit[k];
	}
	delete[] realAnsDigit;

	if (backgroundTexture1) glDeleteTextures(1, &backgroundTexture1);
	if (backgroundTexture2) glDeleteTextures(1, &backgroundTexture2);
	if (logo) glDeleteTextures(1, &logo);
	if (numberTexture) glDeleteTextures(1, &numberTexture);
	
	
	

	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end

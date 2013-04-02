/*
 *  SnowBall.h
 *  SnowMath
 *
 *  Created by ananda on 10/1/11.
 *  Copyright 2011 香川高専（宅間）. All rights reserved.
 *
 */
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

class SnowBall {
public:	
	int ballIndex;
	float ballX;
	float ballY;
	float ballAngle;
	float ballSize;
	float ballSpeed;
	float ballTurnAngle;
	GLuint snowballTexture;
	bool falldown;

	SnowBall();
	SnowBall(int ballIndex,float ballX,float ballY,float ballAngle,float ballSize,float ballSpeed,float ballTurnAngle,GLuint snowballTexture);
	
	void ballMove();   //displacement of the snowball
	void balldoWarp(); //if the snowball is out of the bound,take it inside
	void balldoWarpSnow();
	
};




/*
 *  SnowBall.mm
 *  SnowMath
 *
 *  Created by ananda on 10/1/11.
 *  Copyright 2011 香川高専（宅間）. All rights reserved.
 *
 */

#include "SnowBall.h"
#include "ES1Renderer.h"

SnowBall::SnowBall(){
}

SnowBall::SnowBall(int ballIndex,float ballX,float ballY,float ballAngle,float ballSize,float ballSpeed,float ballTurnAngle,GLuint snowballTexture){
	this->ballIndex = ballIndex;
	this->ballX = ballX;
	this->ballY = ballY;
	this->ballAngle = ballAngle;
	this->ballSize = ballSize;
	this->ballSpeed = ballSpeed;
	this->ballTurnAngle = ballTurnAngle;
	this->falldown = false;
	this->snowballTexture = snowballTexture;

}

void SnowBall::ballMove(){
	float theta = this->ballAngle / 180.0f * M_PI;
	this->ballX = this->ballX + cos(theta) * this->ballSpeed;
	this->ballY = this->ballY - this->ballSpeed;
	
}

void SnowBall::balldoWarp(){
	if (this->ballX >= 0.80f) {
		this->ballAngle=-120.0f;
		this->ballTurnAngle=0.0f;
	}
	if (this->ballX <= -0.80f) {
		this->ballAngle=-30.0f;
		this->ballTurnAngle=0.0f;
	}
	if (this->ballY <=  -1.60f){
		this->ballY = 1.70f;
		falldown = true;
	}
}
void SnowBall::balldoWarpSnow(){
	if (this->ballX >= 1.0f) {
		this->ballAngle=-120.0f;
		this->ballTurnAngle=0.0f;
	}
	if (this->ballX <= -1.0f) {
		this->ballAngle=-30.0f;
		this->ballTurnAngle=0.0f;
	}
	if (this->ballY <=  -2.0f){
		this->ballY = 2.0f;
		falldown = true;
	}
}


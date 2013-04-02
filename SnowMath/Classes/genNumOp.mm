/*
 *  genNumOp.mm
 *  SnowMath
 *
 *  Created by ananda on 10/1/11.
 *  Copyright 2011 香川高専（宅間）. All rights reserved.
 *
 */

#include "genNumOp.h"
#define randF() ((int)(rand() % 10))

genNumOp::genNumOp(){

	this->numIndex = numIndex;
	
	//generating two numbers and then the digits
	numGenTech();	
}
void genNumOp::numGenTech(){
	
	this->op = arc4random() % 3 + 10;//operator is fixed to 'plus' sign
	
	
	//i need to work here for different operation
	num1 = arc4random() % 40 ;
	if (num1 == 0) {
		num1 = num1 + arc4random() % 50 + 1; 
	}
	
	num2 = arc4random() % 20 ;
	if (num2 == 0) {
		num2 = num2 + arc4random() % 50 + 1; 
	}
	
	if (this->op == 11) {
		if (num1 < num2) {
			int tmp;
			tmp = num1;
			num1 = num2;
			num2 = tmp;
		}
	}
	
		
}
int genNumOp::digitCount(int realAns){
	return floor( log10( abs( realAns != 0 ? realAns: 1 ) ) ) + 1 ;
}



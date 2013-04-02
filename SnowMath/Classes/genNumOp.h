/*
 *  genNumOp.h
 *  SnowMath
 *
 *  Created by ananda on 10/1/11.
 *  Copyright 2011 香川高専（宅間）. All rights reserved.
 *
 */

class genNumOp {
public:
	int numIndex;
	int digitDensity ;
	int num1;
	int digNum1;
	int num2;
	int digNum2;
	int nowAns;
	int upNum1;   //first digit from left of the first Num
	int upNum2;   //second digit from left of the first Num
	int downNum1; //first digit from left of the second Num
	int downNum2; //second digit from left of the second Num
	
	int op; //operator
	
	
	genNumOp();
	int digitCount(int realAns);
	void numGenTech();

};


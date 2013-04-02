/*
 *  graphicUtil.mm
 *
 * 「OpenGLで作るiPhone SDKゲームプログラミング」(ISBN-10: 4844328085)
 * 第一章で作成する、ポリゴンやテクスチャを簡単に描画するためのグラフィックライブラリです。
 * このライブラリは、第五章で若干改良されます。
 *
 * なお、このファイルには本文中ではスペースの都合上掲載しきれなかったコメントも掲載されています。
 */

#include "graphicUtil.h"

//画面の中央に赤い四角形を描画します
void drawSquare(){
	drawSquare2(255, 0, 0, 255);
}

//画面の中央に指定した色で四角形を描画します
void drawSquare2(int red, int green, int blue, int alpha){
	drawSquare3(0.0f, 0.0f, red, green, blue, alpha);
}

//画面の指定した座標に指定した色で四角形を描画します
void drawSquare3(float x, float y, int red, int green, int blue, int alpha){
	drawRectangle(x, y, 1.0f, 1.0f, red, green, blue, alpha);
	
}

//画面上に長方形を描画します
void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha){
	
	//長方形を構成する四つの頂点の座標を決定します
	const GLfloat squareVertices[] = {
        -0.5f*width + x,	-0.5f*height + y,
		 0.5f*width + x,	-0.5f*height + y,
        -0.5f*width + x,	 0.5f*height + y,
		 0.5f*width + x,	 0.5f*height + y,
    };
	
	//長方形を構成する四つの頂点の色を指定します
	//ここではすべての頂点を同じ色にしています
    const GLubyte squareColors[] = {
        red, green, blue ,alpha,
        red, green, blue ,alpha,
		red, green, blue ,alpha,
		red, green, blue ,alpha,
    };
	
	//長方形を描画します
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
}

//指定した位置にテクスチャを描画します
void drawTexture(float x, float y, float width, float height, GLuint texture, int red, int green, int blue, int alpha){
	drawTexture2(x, y, width, height, texture, 0.0f, 0.0f, 1.0f, 1.0f, red, green, blue, alpha);
}

//指定した位置にテクスチャを描画します
//その際、元のテクスチャ画像のどの範囲を描画するかを指定します
void drawTexture2(float x, float y, float width, float height, GLuint texture, float u, float v, float tex_width, float tex_height, int red, int green, int blue, int alpha){
	
	//長方形を構成する四つの頂点の座標を決定します
	const GLfloat squareVertices[] = {
        -0.5f*width + x,	-0.5f*height + y,
		 0.5f*width + x,	-0.5f*height + y,
        -0.5f*width + x,	 0.5f*height + y,
		 0.5f*width + x,	 0.5f*height + y,
    };
	
	//長方形を構成する四つの頂点の色を指定します
	//ここではすべての頂点を同じ色にしています
    const GLubyte squareColors[] = {
        red, green, blue ,alpha,
        red, green, blue ,alpha,
		red, green, blue ,alpha,
		red, green, blue ,alpha,
    };
	
	//元画像のどの範囲を描画に使うかを決定します
	const GLfloat texCoords[] = {
		u,				v+tex_height,
		u+tex_width,	v+tex_height,
		u,				v,
		u+tex_width,	v,
	};
	
	//テクスチャ機能を有効にし、描画に使用するテクスチャを指定します
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture);
	
	//頂点座標と色、およびテクスチャの範囲を指定し、描画します
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	//テクスチャ機能を無効にします
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
}

//1桁の数字を描画します
void drawNumber(float x, float y, float width, float height, GLuint texture, int number, int red, int green, int blue, int alpha){
	
	//数字「number」が格納されている画像上の座標を計算します
	float u = (float)(number % 4) * 0.25f;
	float v = (float)(number / 4) * 0.25f;
	
	//画像を使って描画します
	drawTexture2(x, y, width, height, texture, u, v, 0.25f, 0.25f, red, green, blue, alpha);
}

//複数桁の数値を描画します
void drawNumbers(float x, float y, float width, float height, GLuint texture, int number, int figures, int red, int green, int blue, int alpha){
	float totalWidth = width * (float)figures;	//n文字分の横幅
	float rightX = x + (totalWidth * 0.5f);	//右端のx座標
	float fig1X = rightX - width * 0.5f;		//1の桁（一番右の桁）の数字の中心のx座標
	
	//一桁ずつ描画していきます
	for(int i=0; i<figures; i++){
		float figNX = fig1X - (float)i * width;	//n桁目の数字の中心のx座標
		int numberToDraw = number / (int)pow(10.0, (double)i) % 10;
		drawNumber(figNX, y, width, height, texture, numberToDraw, 255, 255, 255, 255);
	}
}

void drawSymbol(float x,float y,float height,float width,int i,GLuint texture)
{
	if (i == 0) {
		drawTexture2(x, y, height, width, texture,-0.01f,0.02f,0.18f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 1){
		drawTexture2(x, y, height, width, texture,0.145f,0.02f,0.168f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 2){
		drawTexture2(x, y, height, width, texture,0.28f,0.02f,0.19f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 3){
		drawTexture2(x, y, height, width, texture,0.445f,0.02f,0.18f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 4){
		drawTexture2(x, y, height, width, texture,0.60f,0.02f,0.187f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 5){
		drawTexture2(x, y, height, width, texture,-0.01f,0.34f,0.176f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 6){
		drawTexture2(x, y, height, width, texture,0.145f,0.34f,0.175f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 7){
		drawTexture2(x, y, height, width, texture,0.30f,0.34f,0.175f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 8){
		drawTexture2(x, y, height, width, texture,0.45f,0.34f,0.176f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 9){
	    drawTexture2(x, y, height, width, texture,0.60f,0.34f,0.185f,0.23f, 255, 255, 255, 255);
		
	}
	else if(i == 10){
		drawTexture2(x, y, height, width, texture,-0.01f,0.71f,0.19f,0.24f, 255, 255, 255, 255);
		
		
	}
	else if(i == 11){
		drawTexture2(x, y, height, width, texture,0.16f,0.74f,0.14f,0.19f, 255, 255, 255, 255);
		
	}
	else if(i == 12){
		drawTexture2(x, y, height, width, texture,0.30f,0.74f,0.16f,0.22f, 255, 255, 255, 255);
		
	}
	else if(i == 13){
		//glPushMatrix();
		//glRotatef(-10.0f, 0.0f, 0.0f, 1.0f);
		drawTexture2(x, y, height, width, texture,0.45f,0.71f,0.19f,0.23f, 255, 255, 255, 255);
		//glPopMatrix();
	}
	
	
}


//円を描画します
void drawCircle(float x, float y, int divides, float radius, int red, int green, int blue, int alpha){
	GLfloat vertices[divides * 3 * 2];	//頂点の要素数はn角形の場合n*3*2になります
	
	int vertexId = 0;	//頂点配列の要素の番号を記憶しておくための変数です
	for (int i=0; i<divides; i++){
		//i番目の頂点の角度(ラジアン)を計算します
		float theta1 = 2.0f / (float)divides * (float)i * M_PI;
		//(i+1)番目の頂点の角度(ラジアン)を計算します
		float theta2 = 2.0f / (float)divides * (float)(i+1) * M_PI;
		
		//i番目の三角形の0番目の頂点の情報をセットします（原点）
		vertices[vertexId++] = x;
		vertices[vertexId++] = y;
		
		//i番目の三角形の1番目の頂点の情報をセットします（円周上のi番目の頂点）
		vertices[vertexId++] = x + cos(theta1) * radius;	//x座標
		vertices[vertexId++] = y + sin(theta1) * radius;	//y座標
		
		//i番目の三角形の2番目の頂点の情報をセットします（円周上のi+1番目の頂点）
		vertices[vertexId++] = x + cos(theta2) * radius;	//x座標
		vertices[vertexId++] = y + sin(theta2) * radius;	//y座標
	}
	
	//ポリゴンの色を指定します
	glColor4ub(red, green, blue, alpha);
	glDisableClientState(GL_COLOR_ARRAY);	//頂点の色配列を無効にしておきます
	
	//頂点配列をセットして、ポリゴンを描画します
	glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
	//n個のポリゴンで構成され、各ポリゴンは3つの頂点を持っているので
	//頂点の数はdivides * 3となります
    glDrawArrays(GL_TRIANGLES, 0, divides * 3);
}

//画像ファイルからテクスチャを作成します
GLuint loadTexture(NSString* fileName){
	GLuint texture;
	
	//画像ファイルを展開しCGImageRefを生成します
	CGImageRef image = [UIImage imageNamed:fileName].CGImage;
	if(!image){	//画像ファイルの読み込みに失敗したらfalse(0)を返します
		NSLog(@"Error: %@ not found",fileName);
		return 0;
	}
	
	//画像の大きさを取得します
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	//ビットマップデータを用意します
	GLubyte* imageData = (GLubyte *) malloc(width * height * 4);
	CGContextRef imageContext = CGBitmapContextCreate(imageData,width,height,8,width * 4,CGImageGetColorSpace(image),kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(imageContext, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), image);
	CGContextRelease(imageContext);
	
	//OpenGL用のテクスチャを生成します
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);	
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	free(imageData);
	
	//作成したテクスチャを返します
	return texture;
}
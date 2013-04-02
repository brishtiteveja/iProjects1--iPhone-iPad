/*
 *  graphicUtil.h
 *
 * 「OpenGLで作るiPhone SDKゲームプログラミング」(ISBN-10: 4844328085)
 * 第一章で作成する、ポリゴンやテクスチャを簡単に描画するためのグラフィックライブラリです。
 * このライブラリは、第五章で若干改良されます。
 */

//OpenGL関連のヘッダーファイルをインポートします
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//ここから関数の定義です
void drawSquare();
void drawSquare2(int red, int green, int blue, int alpha);
void drawSquare3(float x, float y, int red, int green, int blue, int alpha);

void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha);

void drawTexture(float x, float y, float width, float height, GLuint texture, int red, int green, int blue, int alpha);
void drawTexture2(float x, float y, float width, float height, GLuint texture, float u, float v, float tex_width, float tex_height, int red, int green, int blue, int alpha);

void drawCircle(float x, float y, int divides, float radius, int red, int green, int blue, int alpha);

void drawNumber(float x, float y, float width, float height, GLuint texture, int number, int red, int green, int blue, int alpha);
void drawNumbers(float x, float y, float width, float height, GLuint texture, int number, int figures, int red, int green, int blue, int alpha);

void drawSymbol(float x,float y,float height,float width,int i, GLuint texture);

void createProblem();

GLuint loadTexture(NSString* fileName);
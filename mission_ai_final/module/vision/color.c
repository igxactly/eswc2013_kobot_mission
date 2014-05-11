#include "module/vision/vision.h"

//const ColorBoundary blue_B = {190, 250, 70, 100, 70, 100};
const ColorBoundary blue_B = {190, 250, 39, 100, 32, 100};
const ColorBoundary red_B = {345, 15, 45, 100, 40, 100};
const ColorBoundary yellow_B = {50, 76, 50, 100, 81, 100};
const ColorBoundary green_B = {120, 168, 47, 100, 18, 100};
//const ColorBoundary green_B = {100, 170, 20, 100, 30, 100};
const ColorBoundary error_B = {-1, -1, -1, -1, -1, -1};

int isColor(HSV hsv, ColorBoundary color_B){

    if(color_B.hmax < color_B.hmin){    // 색이 Red 일 경우
	    if(hsv.h >= color_B.hmin && hsv.h <= 360 &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return _TRUE_;

        else if(hsv.h >= 0 && hsv.h <= color_B.hmax &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return _TRUE_;

        else
            return _FALSE_;
    }

    else{    // 그 외 경우

        if(hsv.h >= color_B.hmin && hsv.h <= color_B.hmax &&
            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&
            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return _TRUE_;

        else
            return _FALSE_;
    }

}

HSV ycbcr2HSV(VideoCopy* buf,int x, int y) {
	int r, g, b;
	float h, s, v;

	ycbcr2rgb(buf, x, y, &r, &g, &b);	// ycbcr422 -> rgb

	RGBtoHSV(r, g, b, &h, &s, &v);		// rgb -> HSV

	HSV hsv = {h, s, v};
	return hsv;
}

void ycbcr2rgb(VideoCopy* buf, int cx, int cy, int* r, int* g, int* b){

	int y, cb, cr;
	int index = cy * MAX_X + cx;
	
	*r = *g = *b = 0;

	// set ycbcr val
	y = buf->ycbcr.y[index];

	cb = buf->ycbcr.cb[index/2];

	cr = buf->ycbcr.cr[index/2];

	*r = min( max( ((y-16))*255.0/219.0 + 1.402*((cr-128)*255.0)/224.0 + 0.5 ,  0 ) ,  255);
	*g = min( max( ((y-16))*255.0/219.0 - 0.344*((cb-128)*255.0)/224.0 - 0.714*((cr-128)*255.0)/224.0 + 0.5 ,  0 ) ,  255);
	*b = min( max( ((y-16))*255.0/219.0 + 1.772*((cb-128)*255.0)/224.0 + 0.5 , 0 ) ,  255);

}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;
	
	min = MIN_3(r, g, b);
	max = MAX_3(r, g, b);
	*v = max; // v
	
	delta = max - min;

	if(delta == 0){

		*s = 0;
		*h = 0;
		*v = *v / 255.0;
		return;
	}

	if( max != 0 )
		*s = delta / max; // s
	else {
		// r = g = b = 0 // s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}

	if( r == max )
		*h = ( g - b ) / delta; // between yellow & magenta

	else if( g == max )
		*h = 2 + ( b - r ) / delta; // between cyan & yellow

	else
		*h = 4 + ( r - g ) / delta; // between magenta & cyan
	
	*h *= 60; // degrees
	if( *h < 0 )
		*h += 360;

	*s *= 100;
	*v = *v / 255 * 100;
}

/*
 *  Simulate3D.h
 *  towerGame
 *
 *  Created by KCU on 7/13/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

typedef struct VECTOR 
{
	float x,y,z;
}VECTOR;

typedef struct GRAPHICS3D
{
	float fov;    // 카메라 시야 범위.. 한마디로 줌인아웃기능
	float z_far;  // 카메라가 어느지점까지 보이나??
	float z_near; // 얼마나 가까운 지점까지 보나??
	int width;    // 2d의 너비
	int height;   // 2d의 높이
	float aspect; // 화면종횡비
	float w,h,q,scale;   // 데카르트좌표계로 변환하기 위한 변수들..
}GRAPHICS3D;


class CSimulate3D
{
public: 
	CSimulate3D();
	virtual ~CSimulate3D();

private:
	void SetViewport(GRAPHICS3D* graphics, int width, int height);	
	void SetProjection(GRAPHICS3D* graphics,float fov,float z_far,float z_near);
	float GetX(GRAPHICS3D* graphics,float x,float z);
	float GetY(GRAPHICS3D* graphics,float y,float z);
	CGPoint Calc(GRAPHICS3D* graphics,float x, float y, float z);
	
public:
	CGPoint Calc2DPosition(float x, float y, float z);
	
private:
	GRAPHICS3D gDraw3D;
};
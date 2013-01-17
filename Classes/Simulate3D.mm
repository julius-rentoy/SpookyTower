/*
 *  Simulate3D.mm
 *  towerGame
 *
 *  Created by KCU on 7/13/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Simulate3D.h"

CSimulate3D::CSimulate3D()
{
}

CSimulate3D::~CSimulate3D()
{
}

void CSimulate3D::SetViewport(GRAPHICS3D* graphics, int width, int height)
{
	graphics->width=width;
	graphics->height=height;
}

void CSimulate3D::SetProjection(GRAPHICS3D* graphics,float fov,float z_far,float z_near)
{
	graphics->fov=fov;
	graphics->z_far=z_far;
	graphics->z_near=z_near;
	graphics->aspect=graphics->height/(float)graphics->width;
	graphics->w=graphics->aspect*cosf(graphics->fov)/sinf(graphics->fov);
	graphics->h=cosf(graphics->fov)/sinf(graphics->fov);
	graphics->q=graphics->z_far/(graphics->z_far-graphics->z_near);
	graphics->scale=10; //You can custome
}

// 좌표범위를 -1 ~ +1 로 매치시킨후 2D 좌표계로 이동시킨다..
float CSimulate3D::GetX(GRAPHICS3D* graphics,float x,float z)
{
	return (graphics->width/2)+graphics->scale*graphics->w*x/z;
}

float CSimulate3D::GetY(GRAPHICS3D* graphics,float y,float z)
{
	return graphics->height-((graphics->height/2)+graphics->scale*graphics->h*y/z);
}


// 폴리곤을 삼각형리스트형식으로 그린다..
CGPoint CSimulate3D::Calc(GRAPHICS3D* graphics,float x, float y, float z)
{
	// z값이 z_near보다 작다면 강제로 z_near로 세팅한다..
	// 원래 이부분은 카메라 삼각뿔과 폴리곤과의 평면의 방정식으로 
	// 클리핑 여부를 판단해야 하는데 여기에서 클리핑 처리는 하지 않았기때문에
	// 그냥 강제로 세팅했다..
	float retX, retY, retZ;
	
	if(z< graphics->z_near)
		retZ=graphics->z_near;
	else
		retZ = z;
			
	// 데카르트좌표계로 변환한다..-1.0f ~ +1.0f 로 투영함..
	retX=graphics->w*x/retZ;
	retY=graphics->h*y/retZ;
	retZ=graphics->q*(1.0f-(graphics->z_near/retZ));   
			
	// 2D좌표계로 변환
	retX=GetX(graphics,retX,retZ);
	retY=GetY(graphics,retY,retZ);
	return CGPointMake(retX, retY);
}

// 3D좌표데이타..이동,회전,카메라변환까지 적용된 좌표라고 가정한다..
CGPoint CSimulate3D::Calc2DPosition(float x, float y, float z)
{
	SetViewport(&gDraw3D, ipx(320), ipy(480));
	SetProjection(&gDraw3D, 0.8f, 10.0f, 0.5f);
	
	// 모니터로 그림.. 물론 입력된 3D좌표값은 카메라 변환까지 적용된 상태라고 가정한다..
	return Calc(&gDraw3D, x, y, z);
}
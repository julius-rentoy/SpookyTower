/*
 *  House.mm
 *  towerGame
 *
 *  Created by KCU on 7/12/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "House.h"
#import "GameLogic.h"
#import "CrashDetectUtils.h"

@implementation House
@synthesize m_bFall;
@synthesize hidden;
@synthesize m_fX;
@synthesize m_fY;
@synthesize m_houseType;
@synthesize m_bPerfect;
@synthesize m_fFallAngle;
@synthesize m_nColor;
#define FALL_SPEED 10
//#define DEBUGLINE	1

float g_coordinate1[6][3][2] = { {{2, 15}, {0, 0}, {-28, 29}},
						{{2, 13}, {0, 0}, {-29, 24}},
						{{3, 16}, {0, 0}, {-27, 26}},
						{{2, 21}, {0, 0}, {-26, 27}},
						{{2, 26}, {0, 0}, {-26, 30}}, 
						{{2, 32}, {0, 0}, {-25, 31}}
};

float g_coordinate2[5][3][2] = {	{{2, 35}, {0, 0}, {-23, 31}},
									{{1, 39}, {0, 0}, {-23, 34}},
									{{2, 42}, {0, 0}, {-23, 41}},
									{{1, 46}, {0, 0}, {-23, 37}},
									{{2, 49}, {0, 0}, {-24, 39}}
};

- (id) init
{
	if ( (self=[super init]))
	{
		m_fX = 0;
		m_fY = 0;
		m_fAlpha = 0;
		m_nFallTime = 0;
		m_aniHouse	= [[Animation alloc] init];
		m_aniEffect	= [[Animation alloc] init];
		m_aniDestroy	= [[Animation alloc] init];
		resManager	= [ResourceManager sharedResourceManager];
		m_fSwingWidth = 0;
		m_bNeedDestroy = NO;
		m_houseType = HOUSETYPE_ONE;
		m_nColor = random()%4;
		hidden = NO;
	}
	
	return self;
}

- (CGRect) getFrame
{
	float fSwingAngle = [GameLogic getSwingAngle];
	float fSwingXOffset = m_fSwingWidth*cos(fSwingAngle);

	return CGRectMake(ipx(m_fX-76/2+fSwingXOffset), ipy(m_fY), 76, 58);
}

- (CGRect) getAbsoluteFrame
{
	float fSwingAngle = [GameLogic getSwingAngle];
	float fSwingXOffset = m_fSwingWidth*cos(fSwingAngle);
	
	float fBaseY = [GameLogic getBaseLineY];
	return CGRectMake(m_fX-76/2+fSwingXOffset, m_fY+fBaseY, 76, 58);
}

- (void) drawDebugLine
{
#ifdef DEBUGLINE
	float yOffset = [GameLogic getBaseLineY];
	if (!m_bFall)
		yOffset = 0;
	
	CGPoint poli[4];	
	CGRect rtObject = [self getFrame];
	rtObject.origin.y += yOffset;
	float x = rtObject.origin.x;
	float y = rtObject.origin.y;
	float width = CGRectGetWidth(rtObject);
	float height = CGRectGetHeight(rtObject);
	
	poli[0] = rtObject.origin;
	poli[1] = CGPointMake(x+width, y);
	poli[2] = CGPointMake(x+width, y + height);
	poli[3] = CGPointMake(x, y + height);
	ccDrawPoly(poli, 4, YES);
	
#endif	
}

- (void) draw: (float) x y:(float) y fAlpha:(float) fAlpha
{
	if (hidden)
		return;
	
	y -= 95;
	
	if (m_bFall)
	{
		x = m_fX;
		y = m_fY;
	}
	
	CCSprite*sprite;

	if (sin(fAlpha) >= 0.3)
	{
		NSString* spriteName = [NSString stringWithFormat: @"dp14_%d", m_nColor];
		
		sprite = [resManager getTextureWithName: spriteName];
	}
	else if (sin(fAlpha) >= -0.3)
	{
		NSString* spriteName = [NSString stringWithFormat: @"dp15_%d", m_nColor];

		sprite = [resManager getTextureWithName: spriteName];
	}
	else
	{
		NSString* spriteName = [NSString stringWithFormat: @"dp16_%d", m_nColor];

		sprite = [resManager getTextureWithName: spriteName];
	}
	
	if (m_bFocus)
	{
		[sprite setColor: ccc3(0xEE, 0xAA, 0xAE)];
	}
	else
	{
		[sprite setColor: ccc3(255, 255, 255)];
	}
	
	[sprite setRotation: -cos(fAlpha)*10];

	CGPoint point = [self calcCB: ccp(x, y) sprite: sprite];
	[sprite setPosition: point];
	[sprite visit];
	
	if (m_bFall)
	{
		m_nFallTime += 0.25f;
		m_fY -= 9.8*2*m_nFallTime;
		return;
	}
	
	m_fX = x;
	m_fY = y;
	
	[self drawDebugLine];
}

- (CGPoint) calcCB: (CGPoint) ptCB sprite:(CCSprite*) sprite
{
	CGSize size = [sprite contentSize];
	
	//ptLB.x += size.width/2.0f;
	float scaleY = sprite.scaleY;	
	ptCB.y += size.height*scaleY/2.0f;
	return ptCB;
}

- (CGPoint) calcOffsetForChild: (CCSprite*) sprite spriteChild: (CCSprite*) spriteChild childId: (int) childId 
{
	CGSize size = [sprite contentSize];
	CGSize sizeChild = [spriteChild contentSize];
	
	CGPoint retPoint;
	retPoint.x = g_coordinate1[childId][0][0];
	retPoint.y = size.height - (g_coordinate1[childId][0][1]+sizeChild.height);
	return retPoint;
}

- (CGPoint) calcOffsetForChild2: (CCSprite*) sprite spriteChild: (CCSprite*) spriteChild childId: (int) childId 
{
	CGSize size = [sprite contentSize];
	CGSize sizeChild = [spriteChild contentSize];
	
	CGPoint retPoint;
	retPoint.x = g_coordinate2[childId][0][0];
	retPoint.y = size.height - (g_coordinate2[childId][0][1]+sizeChild.height);
	return retPoint;
}

- (CGPoint) calcOffsetForSide: (CCSprite*) sprite spriteSide: (CCSprite*) spriteSide sideId: (int) sideId 
{
	CGSize size = [sprite contentSize];
	CGSize sizeSide = [spriteSide contentSize];
	
	CGPoint retPoint;
	retPoint.x = g_coordinate1[sideId][2][0]/2;
	retPoint.y = size.height - (g_coordinate1[sideId][2][1]*1.5+sizeSide.height);
	return retPoint;
}

- (CGPoint) calcOffsetForSide2: (CCSprite*) sprite spriteSide: (CCSprite*) spriteSide sideId: (int) sideId 
{
	CGSize size = [sprite contentSize];
	CGSize sizeSide = [spriteSide contentSize];
	
	CGPoint retPoint;
	retPoint.x = g_coordinate2[sideId][2][0]/2;
	retPoint.y = size.height - (g_coordinate2[sideId][2][1]*1+sizeSide.height);
	return retPoint;
}

- (void) drawSpriteToCB: (NSString*) spriteName point:(CGPoint) point
{
	CCSprite*sprite = [resManager getTextureWithName: spriteName];
	CGPoint pointCB = [self calcCB: point sprite: sprite];
	[sprite setPosition: pointCB];
	[sprite visit];
}

- (void) drawAngleSpriteToCB: (NSString*) spriteName point:(CGPoint) point angle: (float) angle
{
	CCSprite*sprite = [resManager getTextureWithName: spriteName];
	CGPoint pointCB = [self calcCB: point sprite: sprite];
	[sprite setPosition: pointCB];
	[sprite setRotation: angle];
	[sprite visit];
}

//bubble effect
- (void) drawCrashEffect1
{
	float fBaseY = [GameLogic getBaseLineY];
	float fCrashCycle = m_aniEffect.m_nCurFrame;
	if (fCrashCycle >= 0 && fCrashCycle <= 5)
	{
		[self drawSpriteToCB: @"bcrashleft1" point: ccp(m_fX-35, m_fY+fBaseY)];
		[self drawSpriteToCB: @"bcrashright1" point: ccp(m_fX+35, m_fY+fBaseY)];
	}
	else if (fCrashCycle >= 6 && fCrashCycle <= 10)
	{
		[self drawSpriteToCB: @"bcrashleft2" point: ccp(m_fX-40, m_fY+fBaseY)];
		[self drawSpriteToCB: @"bcrashright2" point: ccp(m_fX+40, m_fY+fBaseY)];
	}
	else if (fCrashCycle >= 11 && fCrashCycle <= 15)
	{
		[self drawSpriteToCB: @"bcrashleft3" point: ccp(m_fX-45, m_fY+fBaseY)];
		[self drawSpriteToCB: @"bcrashright3" point: ccp(m_fX+45, m_fY+fBaseY)];
	}
	else if (fCrashCycle >= 16 && fCrashCycle <= 20)
	{
		[self drawSpriteToCB: @"bcrashleft4" point: ccp(m_fX-50, m_fY+fBaseY)];
		[self drawSpriteToCB: @"bcrashright4" point: ccp(m_fX+50, m_fY+fBaseY)];
	}
}

//tink effect
- (void) drawCrashEffect2
{
	float fBaseY = [GameLogic getBaseLineY];
	float fCrashCycle = m_aniEffect.m_nCurFrame;
	if (fCrashCycle <= 50)
	{
		[self drawAngleSpriteToCB: @"btink3" point: ccp(m_fX-35, m_fY+fBaseY) angle: fCrashCycle];
		[self drawAngleSpriteToCB: @"btink4" point: ccp(m_fX+35, m_fY+fBaseY) angle: fCrashCycle];
	}
	
	if (fCrashCycle >= 40 && fCrashCycle <= 100)
	{
		[self drawAngleSpriteToCB: @"btink3" point: ccp(m_fX, m_fY+fBaseY+20) angle: fCrashCycle];
		[self drawAngleSpriteToCB: @"btink1" point: ccp(m_fX-35, m_fY+fBaseY) angle: fCrashCycle];
		[self drawAngleSpriteToCB: @"btink1" point: ccp(m_fX+35, m_fY+fBaseY+40) angle: fCrashCycle];
	}
}

//bubble effect1
#define PI 3.141592
- (void) drawBubbleEffect
{
	if (m_aniEffect.m_nCurFrame >= 30)
		return;
	
	float fBaseY = [GameLogic getBaseLineY];
	float fCrashCycle = (m_aniEffect.m_nCurFrame+20)*2;

	if (m_aniEffect.m_nCurFrame <= 20)
	{
		CCSprite* sprite = [[ResourceManager sharedResourceManager] getTextureWithName: @"c73"];
		[sprite setColor: ccc3(100, 100, 100)];
		[sprite setOpacity: 255-m_aniEffect.m_nCurFrame*3];
		[sprite setPosition: ccp(m_fX, fBaseY+m_fY)];
		float fScale = (m_aniEffect.m_nCurFrame*0.4+1);
		[sprite setScaleX: fScale];
		[sprite setScaleY: fScale/3.0f];
		[sprite visit];
	}
	
	float x = m_fX+cos(0) * fCrashCycle;
	float y = m_fY + sin(0)*fCrashCycle/2;		
	[self drawAngleSpriteToCB: @"b134" point: ccp(x, fBaseY+y) angle: 2.5*fCrashCycle];

	x = m_fX+cos(-PI/3.0f) * fCrashCycle;
	y = m_fY + sin(-PI/3.0f)*fCrashCycle/2;		
	[self drawAngleSpriteToCB: @"b135" point: ccp(x, fBaseY+y) angle: 0.8*fCrashCycle];

	x = m_fX+cos(-PI/2.0f) * (fCrashCycle-20);
	y = m_fY + sin(-PI/2.0f)*(fCrashCycle-20)/2;		
	[self drawAngleSpriteToCB: @"b136" point: ccp(x, fBaseY+y) angle: 1.2*fCrashCycle];
	
	x = m_fX+cos(-PI*2/3.0f) * (fCrashCycle-10);
	y = m_fY + sin(-PI*2/3.0f)*(fCrashCycle-10)/2;		
	[self drawAngleSpriteToCB: @"b136" point: ccp(x, fBaseY+y) angle: 0.5*fCrashCycle];

	x = m_fX+cos(-PI) * (fCrashCycle+10);
	y = m_fY + sin(-PI)*(fCrashCycle+10)/2;		
	[self drawAngleSpriteToCB: @"b136" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];

	x = m_fX+cos(-PI/2.5f) * (fCrashCycle-15);
	y = m_fY + sin(-PI/2.5f)*(fCrashCycle-15)/2;		
	[self drawAngleSpriteToCB: @"b152" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];

	x = m_fX+cos(-PI/4.5f) * (fCrashCycle-25);
	y = m_fY + sin(-PI/4.5f)*(fCrashCycle-15)/2;		
	[self drawAngleSpriteToCB: @"b153" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];

	x = m_fX+cos(PI/3.0f) * (fCrashCycle-5);
	y = m_fY + sin(PI/3.0f)*(fCrashCycle-5)/2;		
	[self drawAngleSpriteToCB: @"b153" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];

	x = m_fX+cos(3*PI/2.0f) * (fCrashCycle-5);
	y = m_fY + sin(3*PI/2.0f)*(fCrashCycle-5)/2;		
	[self drawAngleSpriteToCB: @"b154" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];

	x = m_fX+cos(-3*PI/2.0f) * (fCrashCycle-5);
	y = m_fY + sin(-3*PI/2.0f)*(fCrashCycle-5)/2;		
	[self drawAngleSpriteToCB: @"btink3" point: ccp(x, fBaseY+y) angle: 0.6*fCrashCycle];
	
//	if (fCrashCycle <= 50)
//	{
//		
//	}
}

- (BOOL) visibleInViewport
{
	CGRect rtAbsolute;
	rtAbsolute = [self getAbsoluteFrame];
	
	CGRect rtScreen = CGRectMake(0, 0, 320, 480);
	if (CrashDetectUtils::DetectRectAndRect(rtAbsolute, rtScreen) == CRASH_YES)
		return YES;
	return NO;
}

- (void) drawFloor: (int) nFloor
{
	CCSprite*sprite = [resManager getTextureWithName: [NSString stringWithFormat: @"dp24_%d", m_nColor]
					   ];

	if (m_bFocus)
	{
		[sprite setColor: ccc3(0xA4, 0xE7, 0xFF)];
	}
	else
	{
		[sprite setColor: ccc3(255, 255, 255)];
	}
	
	float fOffsetX = 0;
	float fOffsetY = 0;
	float fSwingAngle = [GameLogic getSwingAngle];
	fOffsetX += m_fSwingWidth*cos(fSwingAngle);

	if ([m_aniDestroy isValid])
	{		
		[m_aniDestroy updateFrame];

		float fCrashCycle = m_aniDestroy.m_nCurFrame;		
		float fCrashAngleCycle = m_aniDestroy.m_fCurValue;
		if (fCrashCycle <= 8)
		{
			fOffsetY = cos(fCrashAngleCycle)*10;
		}
		
		[sprite setRotation: sin(fCrashAngleCycle)*m_fAngleWidth];
		fOffsetX = sin(fCrashAngleCycle)*200;

		if (fCrashCycle >= 8 && fCrashCycle <= 50)
		{
			m_fY -= 10;
		} 

		if ([self visibleInViewport] == NO)
		{
			m_bNeedDestroy = YES;
		}
	}
	
	if ([m_aniHouse isValid])
	{
		[m_aniHouse updateFrame];
		float fCrashCycle = m_aniHouse.m_nCurFrame;		
		float fCrashAngleCycle = m_aniHouse.m_fCurValue;
		if (fCrashCycle <= 20)
		{
			[sprite setRotation: sin(fCrashAngleCycle)*m_fAngleWidth];
			[sprite setScale: (1.0f + 0.3f*cos(fCrashCycle)/fCrashCycle)];

			fOffsetX += sin(fCrashAngleCycle)*m_fAngleWidth;
			fOffsetY += sin(-fabs(fCrashAngleCycle))*m_fAngleWidth/2;
		}
	}
	else
	{
		if (![m_aniDestroy isValid])
		{
			[sprite setScale: 1.0f];
//			float fSwingAngle = [GameLogic getSwingAngle];
//			fOffsetX += m_fSwingWidth*cos(fSwingAngle);
//			[sprite setRotation: sin(fSwingAngle)*m_fSwingWidth/5];
//			[spriteChild setRotation: sin(fSwingAngle)*m_fSwingWidth/5];
		}
	}
	
	if ([m_aniEffect isValid])
	{
		if (m_bPerfect)
			[self drawBubbleEffect];
		[m_aniEffect updateFrame];
	}	
	
	float fBaseY = [GameLogic getBaseLineY];	

	float fX = m_fX+fOffsetX;
	float fY = m_fY+fBaseY+fOffsetY;
	CGPoint point = [self calcCB: ccp(m_fX+fOffsetX, m_fY+fBaseY+fOffsetY) sprite: sprite];
	[sprite setPosition: point];
	[sprite visit];

	if ([m_aniEffect isValid])
	{
//		[m_aniEffect updateFrame];
		[self  drawCrashEffect1];
		[self  drawCrashEffect2];
	}
	
	[self drawDebugLine];	
}

- (BOOL) canDestroyFloor
{
	return m_bNeedDestroy;
}

- (void) setX: (float) x
{
	m_fX = x;
}

- (void) setFocus: (BOOL) bFocus
{
	m_bFocus = bFocus;
}

- (void) fallHouse: (BOOL) bFall
{
	m_nFallTime = 0;
	m_bFall = bFall;
}

- (void) startCrashAnimation: (float) fAngle bEffect: (BOOL) bEffect
{
	NSLog(@"angle = %f", fAngle);

	if (fAngle < 0)
		m_fAngle = -3.14f/20.0f;
	else
		m_fAngle = 3.14f/20.0f;

	m_fAngleWidth = fabs(fAngle)*2;
	if (fabs(fAngle) < 2 )
		m_fAngleWidth = 0;

	[m_aniHouse startAnimation: 20 curFrame: 0 curValue: 0 incValue: m_fAngle];
	[m_aniEffect startAnimation: 100 curFrame: 0 curValue: 0 incValue: 1];
	m_bPerfect = bEffect;
}

- (void) setSwingData: (float) fWidth fAngle: (float) fAngle
{
	m_fSwingWidth = fWidth;
	m_fAngle = fAngle;
}

- (void) startDestroyAnimation2
{
	if (m_fFallAngle < 0)
		m_fAngle = -3.14f/80.0f;
	else
		m_fAngle = 3.14f/80.0f;	

	m_fAngleWidth = 100;
	[m_aniDestroy startAnimation: 100 curFrame: 0 curValue: 0 incValue: m_fAngle];
}

- (void) startDestroyAnimation: (float) fAngle
{
	if (fAngle < 0)
		m_fAngle = -3.14f/80.0f;
	else
		m_fAngle = 3.14f/80.0f;	

	m_fAngleWidth = 100;
	[m_aniDestroy startAnimation: 100 curFrame: 0 curValue: 0 incValue: m_fAngle];
}

@end
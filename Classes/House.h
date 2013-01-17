/*
 *  House.h
 *  towerGame
 *
 *  Created by KCU on 7/12/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"
#import "ResourceManager.h"
#import "Animation.h"

typedef enum 
{
	HOUSETYPE_ONE = 0,
	HOUSETYPE_FA,
	HOUSETYPE_VE,
	HOUSETYPE_COUNT
}HOUSETYPE;

@interface House: NSObject
{

	float m_fX;
	float m_fY;
	float m_fAlpha;
	
	BOOL hidden;
	BOOL m_bFocus;
	BOOL m_bFall;
	float m_nFallTime;
	
	Animation *m_aniHouse;
	Animation *m_aniEffect;
	Animation *m_aniDestroy;
	
	float m_fSwingWidth;
	float m_fSwingAngle;
	float m_fAngle;
	float m_fFallAngle;
	float m_fAngleWidth;
	ResourceManager* resManager;
	
	BOOL m_bNeedDestroy;
	HOUSETYPE m_houseType;
	BOOL m_bPerfect;
	
	int m_nColor;
}

@property (nonatomic) BOOL m_bFall;
@property (nonatomic) BOOL hidden;
@property (nonatomic) float m_fX;
@property (nonatomic) float m_fY;
@property (nonatomic) HOUSETYPE m_houseType;
@property (nonatomic) float m_fFallAngle;
@property (nonatomic) BOOL m_bPerfect;
@property (nonatomic) int m_nColor;


- (id) init;
- (void) setFocus: (BOOL) bFocus;
- (void) setX: (float) x;
- (void) fallHouse: (BOOL) bFall;
- (void) draw:(float) x y:(float) y fAlpha:(float) fAlpha;
- (void) drawFloor: (int) nFloor;
- (CGRect) getFrame;
- (CGRect) getAbsoluteFrame;
- (CGPoint) calcCB: (CGPoint) ptCB sprite:(CCSprite*) sprite;
- (CGPoint) calcOffsetForChild: (CCSprite*) sprite spriteChild: (CCSprite*) spriteChild childId: (int) childId;
- (CGPoint) calcOffsetForSide: (CCSprite*) sprite spriteSide: (CCSprite*) spriteSide sideId: (int) sideId;
- (void) startCrashAnimation: (float) fAngle bEffect: (BOOL) bEffect;
- (void) startDestroyAnimation2;
- (void) startDestroyAnimation: (float) fAngle;
- (void) setSwingData: (float) fWidth fAngle: (float) fAngle;
- (BOOL) canDestroyFloor;
- (BOOL) visibleInViewport;

@end
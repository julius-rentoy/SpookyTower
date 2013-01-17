//
//  ObjectAirplane.m
//  towerGame
//
//  Created by KCU on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectAirplane.h"

#define xStepCount	2000
@implementation ObjectAirplane

- (id) init: (NSDictionary*) data
{
	if ( (self=[super init]) )
	{
		NSString* strName = [data objectForKey: @"name"];
		m_fX = [[data objectForKey: @"x"] floatValue];
		m_fY = [[data objectForKey: @"y"] floatValue];		
		m_fStartX = [[data objectForKey: @"startx"] floatValue];
		m_fEndX = [[data objectForKey: @"endx"] floatValue];		
		m_SprAirplane = [[[ResourceManager sharedResourceManager] getTextureWithName: strName] retain];
	}
	
	return self;
}

- (void) draw
{
	[super draw];
	static int nCount = 0;
	float baseY = [GameLogic getBaseLineY];
	float xStep = (m_fEndX-m_fStartX)/xStepCount;
	float fX = m_fStartX + xStep*nCount;
	float fY = m_fY + baseY;
	[m_SprAirplane setPosition: ccp(fX, fY)];
	[m_SprAirplane visit];
	nCount = (nCount + 1) % xStepCount;
}

@end

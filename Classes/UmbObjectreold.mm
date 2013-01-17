//
//  UmbObject.mm
//  towerGame
//
//  Created by KCU on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UmbObject.h"


@implementation UmbObject

- (id) init
{
	if ( (self=[super init]) )
	{
		srand(320);
		mAnimManager = [[AnimationManager alloc] init];
//		[mAnimManager loadAnimationGroup: [NSString stringWithFormat: @"umbobj%d.plist", arc4random()%4+1]];
//		[mAnimManager beginAnimation: @"Animation 0"];
//		
//		m_fX = arc4random() % 320;
//		m_fY = 500 + arc4random() % 1000;
	}
	
	return self;
}

- (void) drawOnTitleScene
{
	m_fY -= 1.0f;
	if (m_fY < -20)
	{
		m_fY = 500;
		m_fX = arc4random() % 320;
	}
	[mAnimManager drawFrame: ccp(m_fX, m_fY)];
}

- (void) setTargetPosition: (CGPoint) position
{
	mTargetPosition = position;
}

- (void) dealloc
{
	[mAnimManager release];
	[super dealloc];
}

@end

//
//  GameLogic.m
//  towerGame
//
//  Created by KCU on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLogic.h"
#include "Simulate3D.h"
#import "ObjectAirplane.h"

@implementation GameLogic

static GameLogic *_sharedGameLogic = nil;
static float _baseLineY = 0;
static float _swingAngle = 0;

+ (GameLogic*) sharedGameLogic 
{
	if (!_sharedGameLogic) 
	{
		_sharedGameLogic = [[GameLogic alloc] init];
	}
	
	return _sharedGameLogic;
}

+ (GameLogic*) releaseGameLogic 
{
	if (_sharedGameLogic) 
	{
		[_sharedGameLogic release];
	}
	
	return _sharedGameLogic;
}

+ (float) getSwingAngle
{
	return _swingAngle;
}

+ (float) getBaseLineY
{
	return _baseLineY;
}

+ (void) setBaseLineY: (float) y
{
	_baseLineY = y;
}

- (id) init
{
	if( (self=[super init] )) 
	{
		resManager = [ResourceManager sharedResourceManager];
		NSString* optionValuesPath = [[NSBundle mainBundle] pathForResource:@"apartments" ofType:@"plist"];
		mApartmentArray = [[NSArray arrayWithContentsOfFile: optionValuesPath] retain];		
		mObjList = [[NSMutableArray arrayWithCapacity: 10] retain];
        
		[self parseObjects];
	}
	
	return self;
}

- (void) parseObjects
{
	for (unsigned int i = 0; i < [mApartmentArray count]; i ++)
	{
		NSDictionary *dic = [mApartmentArray objectAtIndex: i];
		NSString* strObjType = [dic objectForKey: @"objtype"];
		if (strObjType== nil || [strObjType length] == 0)
			continue;
		if ([strObjType isEqualToString: @"object-airplane"])
		{
			ObjectAirplane *obj = [[[ObjectAirplane alloc] init: dic] autorelease];
			[mObjList addObject: obj];
		}
	}
	
}

- (CGPoint) calcLB: (CGPoint) ptLB sprite:(CCSprite*) sprite
{
	CGSize size = [sprite contentSize];
	ptLB.x += size.width/2.0f;
	ptLB.y += size.height/2.0f;
	return ptLB;
}

- (void) drawSprite: (NSString*) strSprite position: (CGPoint) position
{
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	[sprite setPosition: [self calcLB:position sprite: sprite]];
	[sprite visit];	
}

- (void) drawGradient
{
	glColor4ub(0, 0, 0, 255);
	ccDrawFilledRect(CGPointMake(0, 0), CGPointMake(ipx(320), ipy(480)));
}

- (void) draw
{
	_swingAngle = (_swingAngle + 0.03);
	[self drawGradient];
	//[self drawApartments];
    
    //CCLOG(@"base line!! %f",_baseLineY);
    
	CCSprite* sprite = [resManager getTextureWithName: @"gameback_1"];
	[sprite setPosition: ccp(ipx(160), ipy((465/2+_baseLineY)))];
	[sprite visit];

    //CCLOG(@"sprite 1: %f",sprite1.position.y);
    
	sprite = [resManager getTextureWithName: @"gameback_2"];
	[sprite setPosition: ccp(ipx(160), ipy((455+_baseLineY+670/2)))];
	[sprite visit];

	sprite = [resManager getTextureWithName: @"gameback_3"];
	
	//if (abs(_baseLineY) > 455+680)
    if (abs(_baseLineY) >= 1044)//1102
	{
        [sprite setScale:1.2];
		[sprite setPosition: ccp(ipx(160), ipy(240))];
	}
	else
	{	
		[sprite setPosition: ccp(ipx(160), ipy((455+_baseLineY+670+406/2)))];
	}
	[sprite visit];
}

- (void) dealloc
{
	[super dealloc];
	[mObjList release];
}

@end

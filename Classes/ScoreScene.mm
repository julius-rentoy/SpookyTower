//
//  ScoreScene.mm
//  towerGame
//
//  Created by KCU on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreScene.h"
#import "TitleScene.h"
#import "ResourceManager.h"
#import "CCZoom1Button.h"
#import "CCScrollLayer.h"
#import "ScoreManager.h"
#import "CCUtils.h"
@implementation ScoreScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreScene *layer = [ScoreScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) dealloc
{
	[super dealloc];
	[mLabel release];
}

- (void) createScrollView
{
	/////////////////////////////////////////////////
	// PAGE 1
	////////////////////////////////////////////////
	// create a blank layer for page 1
	CCLayer *pageOne = [QuickScore node];
	
	/////////////////////////////////////////////////
	// PAGE 2
	////////////////////////////////////////////////
	// create a blank layer for page 2
	CCLayer *pageTwo = [TimeAttack node];
	
	
	/////////////////////////////////////////////////
	// PAGE 3
	////////////////////////////////////////////////
	CCLayer *pageThree = [ScoreAttack node];
	
	////////////////////////////////////////////////
	
	// now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
	CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: pageOne,pageTwo,pageThree, nil] widthOffset: 0];
	
	// finally add the scroller to your scene
	[self addChild:scroller];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
		CCZoom1Button* btnBack = [[CCZoom1Button alloc] initWithTarget:self 
															  selector:@selector(goTitleSceneCallback:)  
														   textureName: @"backbutton"
														selTextureName: @"backbutton1"
															  position: CGPointMake(ipx(5), ipy(400))
															 afterTime:0.2f];

		[self addChild: btnBack];		
		[self createScrollView];
	}
	
	return self;
}

- (void) goTitleSceneCallback: (id) sender
{
	CCScene* beginScene = [TitleScene node];
	[[CCDirector sharedDirector] replaceScene:beginScene];		
}

- (void) draw
{
	BackgroundManager* backManager = [BackgroundManager sharedBackgroundManager];
	[backManager draw];
}
@end

@implementation QuickScore
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QuickScore *layer = [QuickScore node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) 
	{
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
		mLabel = [[CCLabelFX labelWithString:@"Quick Score" 
								  dimensions:CGSizeMake(ipx(200), ipy(30)) 
								   alignment:CCTextAlignmentCenter
									fontName:@"Arial" 
									fontSize:ipy(25)
								shadowOffset:CGSizeMake(0,0) 
								  shadowBlur:3.0f 
								 shadowColor:shadowColor 
								   fillColor:fillColor] retain];
		
		mLabel.position = ccp(ipx(100), ipy(100));
        font30 = [ResourceManager sharedResourceManager].font30;
		[font30 setColor: ccc3(43, 77, 121)];
		mScoreArray = [[[ScoreManager sharedScoreManager] loadAllQuickScore] retain];		
	}
	return self;
}

- (void) drawScoreTable
{
	[font30 setString: @"Name"];
	[font30 setPosition: ccp(ipx(100), ipy(360))];
	[font30 visit];		
	
	[font30 setString: @"Floor"];
	[font30 setPosition: ccp(ipx(220), ipy(360))];
	[font30 visit];		
	
	int nCount = [mScoreArray count];
	
	for (int i = 0; i < 10; i ++)
	{
		[font30 setString: [NSString stringWithFormat: @"%d.", i+1]];
		[font30 setPosition: ccp(ipx(50), ipy((150+(9-i)*20)))];
		[font30 visit];
	}
	
	//draw Names
	for (int i = 0 ; i < nCount; i ++)
	{
		NSDictionary *item = [mScoreArray objectAtIndex:i];
		
		NSString* scoreName = [item objectForKey: @"name"];
		[font30 setString: scoreName];
		[font30 setPosition: ccp(ipx(100),ipy( (150+(9-i)*20)))];
		[font30 visit];
		
		NSNumber* aScore = [item objectForKey: @"score"];
		[font30 setString: [NSString stringWithFormat: @"%dF", [aScore intValue]]];
		[font30 setPosition: ccp(ipx(220), ipy((150+(9-i)*20)))];
		[font30 visit];
	}	
	
	//draw Scores
	for (int i = nCount ; i < 10; i ++)
	{
		[font30 setString: @"NoName"]; 
		[font30 setPosition: ccp(ipx(100), ipy((150+(9-i)*20)))];
		[font30 visit];
		
		[font30 setString: @"----"]; 
		[font30 setPosition: ccp(ipx(220), ipy((150+(9-i)*20)))];
		[font30 visit];
	}	
}

- (void) draw
{
	[mLabel setPosition: ccp(ipx(160), ipy(400))];
	[mLabel visit];
	[self drawScoreTable];
}

- (void) dealloc
{
	[super dealloc];
	[mLabel release];
	[font30 release];
	[mScoreArray release];
}
@end

@implementation TimeAttack

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TimeAttack *layer = [TimeAttack node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) 
	{
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
		mLabel = [[CCLabelFX labelWithString:@"Time Attack" 
								  dimensions:CGSizeMake(ipx(200), ipy(30)) 
								   alignment:CCTextAlignmentCenter
									fontName:@"Arial" 
									fontSize:ipy(25)
								shadowOffset:CGSizeMake(0,0) 
								  shadowBlur:3.0f 
								 shadowColor:shadowColor 
								   fillColor:fillColor] retain];
		
		mLabel.position = ccp(100, 100);
        font30 = [ResourceManager sharedResourceManager].font30;
		[font30 setColor: ccc3(43, 77, 121)];
		mScoreArray = [[[ScoreManager sharedScoreManager] loadAllTimeScore] retain];		
	}
	return self;
}

- (void) drawScoreTable
{
	[font30 setString: @"Name"];
	[font30 setPosition: ccp(ipx(100), ipy(360))];
	[font30 visit];		
	
	[font30 setString: @"Score"];
	[font30 setPosition: ccp(ipx(220), ipy(360))];
	[font30 visit];		
	
	int nCount = [mScoreArray count];
	
	for (int i = 0; i < 10; i ++)
	{
		[font30 setString: [NSString stringWithFormat: @"%d.", i+1]];
		[font30 setPosition: ccp(ipx(50), ipy((150+(9-i)*20)))];
		[font30 visit];
	}
	
	//draw Names
	for (int i = 0 ; i < nCount; i ++)
	{
		NSDictionary *item = [mScoreArray objectAtIndex:i];
		
		NSString* scoreName = [item objectForKey: @"name"];
		[font30 setString: scoreName];
		[font30 setPosition: ccp(ipx(100), ipy((150+(9-i)*20)))];
		[font30 visit];
		
		NSNumber* aScore = [item objectForKey: @"score"];
		[font30 setString: [NSString stringWithFormat: @"%d", [aScore intValue]]];
		[font30 setPosition: ccp(ipx(220), ipy((150+(9-i)*20)))];
		[font30 visit];
	}	
	
	//draw Scores
	for (int i = nCount ; i < 10; i ++)
	{
		[font30 setString: @"NoName"]; 
		[font30 setPosition: ccp(ipx(100), ipy((150+(9-i)*20)))];
		[font30 visit];
		
		[font30 setString: @"----"]; 
		[font30 setPosition: ccp(ipx(220), ipx((150+(9-i)*20)))];
		[font30 visit];
	}	
}

- (void) draw
{
	[mLabel setPosition: ccp(ipx(160), ipy(400))];
	[mLabel visit];
	[self drawScoreTable];
}

- (void) dealloc
{
	[super dealloc];
	[mLabel release];
	[font30 release];
	[mScoreArray release];
}
@end

@implementation ScoreAttack
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreAttack *layer = [ScoreAttack node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) 
	{
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
		mLabel = [[CCLabelFX labelWithString:@"Score Attack" 
								  dimensions:CGSizeMake(ipx(200), ipy(30)) 
								   alignment:CCTextAlignmentCenter
									fontName:@"Arial" 
									fontSize:ipy(25)
								shadowOffset:CGSizeMake(0,0) 
								  shadowBlur:3.0f 
								 shadowColor:shadowColor 
								   fillColor:fillColor] retain];
		
        font30 = [ResourceManager sharedResourceManager].font30;
		[font30 setColor: ccc3(43, 77, 121)];
		mScoreArray = [[[ScoreManager sharedScoreManager] loadAllScore] retain];		
	}
	return self;
}

- (void) drawScoreTable
{
	[font30 setString: @"Name"];
	[font30 setPosition: ccp(ipx(100), ipy(360))];
	[font30 visit];		
	
	[font30 setString: @"Floor"];
	[font30 setPosition: ccp(ipx(220), ipy(360))];
	[font30 visit];		
	
	int nCount = [mScoreArray count];
	
	for (int i = 0; i < 10; i ++)
	{
		[font30 setString: [NSString stringWithFormat: @"%d.", i+1]];
		[font30 setPosition: ccp(ipx(50), ipy((150+(9-i)*20)))];
		 [font30 visit];
	}
	
	//draw Names
	for (int i = 0 ; i < nCount; i ++)
	{
		NSDictionary *item = [mScoreArray objectAtIndex:i];
		
		NSString* scoreName = [item objectForKey: @"name"];
		[font30 setString: scoreName];
		[font30 setPosition: ccp(ipx(100), ipy((150+(9-i)*20)))];
		[font30 visit];
		
		NSNumber* aScore = [item objectForKey: @"score"];
		[font30 setString: [NSString stringWithFormat: @"%dF", [aScore intValue]]];
		[font30 setPosition: ccp(ipx(220),ipy((150+(9-i)*20)))];
		[font30 visit];
	}	
	
	//draw Scores
	for (int i = nCount ; i < 10; i ++)
	{
		[font30 setString: @"NoName"]; 
		[font30 setPosition: ccp(ipx(100), ipy((150+(9-i)*20)))];
		[font30 visit];
		
		[font30 setString: @"----"]; 
		[font30 setPosition: ccp(ipx(220), ipy((150+(9-i)*20)))];
		[font30 visit];
	}	
}

- (void) draw
{
	[mLabel setPosition: ccp(ipx(160), ipy(400))];
	[mLabel visit];
	[self drawScoreTable];
}

- (void) dealloc
{
	[super dealloc];
	[mLabel release];
	[mScoreArray release];
}
@end


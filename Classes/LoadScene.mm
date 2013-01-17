//
//  HelloWorldLayer.m
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "LoadScene.h"
#import "TitleScene.h"
#import "QuickGame.h"
#import "ResourceManager.h"
#import "GameLogic.h"
#import "AnimationManager.h"
#import "SoundManager.h"
#import "AppSettings.h"
@implementation LoadScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadScene *layer = [LoadScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
		resManager = [ResourceManager sharedResourceManager]; 
		[resManager loadLoadingData];
        
	}
	return self;
}

- (void) draw
{
	static long tick = 0;
	tick ++;
	
	CCSprite* sprite = [resManager getTextureWithId: kLoading];
	[sprite setPosition: ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
	[sprite visit];
	
	if (tick == 5)
	{
		[AppSettings defineUserDefaults];
		[BackgroundManager sharedBackgroundManager];	
		[SoundManager sharedSoundManager];
		[resManager loadData];
		[GameLogic sharedGameLogic];
		[[CCDirector sharedDirector] replaceScene:[TitleScene node]];	
		
		[[SoundManager sharedSoundManager] setBackgroundVolume: [AppSettings backgroundVolume]];
		[[SoundManager sharedSoundManager] setEffectVolume: [AppSettings effectVolume]];
		
		[[SoundManager sharedSoundManager] playBackgroundMusic: kBBack];
//		[[CCDirector sharedDirector] replaceScene:[QuickGame node]];			
	}
	


}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end

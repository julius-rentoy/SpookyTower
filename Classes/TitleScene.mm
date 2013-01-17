//
//  TitleScene.mm
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "RestoreIAPScene.h"
#import "TitleScene.h"
#import "BeginScene.h"
#import "SettingScene.h"
#import "ScoreScene.h"
#import "CCButton.h"
#import "CCZoomButton.h"
#import "UmbObject.h"
#import "AnimationManager.h"
#import "towerGameAppDelegate.h"

#import "iaAdsManager.h"
@implementation TitleScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScene *layer = [TitleScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    /*
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    //if ( mainDelegate.m_showhint == 1 ) {
        mainDelegate.m_showhint =1;
    [[iaAdsManager sharedAdsManager]  hideAd];
    //}
    
    */
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
		backManager = [BackgroundManager sharedBackgroundManager];
		resManager = [ResourceManager sharedResourceManager]; 

		CCZoomButton* btnPlay = [[CCZoomButton alloc] initWithTarget:self 
												selector:@selector(goBeginSceneCallback:)  
											   textureName: @"title_play"
											selTextureName: @"title_play1"
												 textName: @""
												position: (CGPointMake(ipx(144), ipy(250)))
											   afterTime:0.4f];
		[self addChild: btnPlay];
		
		CCZoomButton* btnScore = [[CCZoomButton alloc] initWithTarget:self 
															 selector:@selector(goScoreSceneCallback:)  
														  textureName: @"title_score"
													   selTextureName: @"title_score1"
															 textName: @""
															 position: (CGPointMake(ipx(144), ipy(290)))
															afterTime:0.6f];
		[self addChild: btnScore];

		CCZoomButton* btnSetting = [[CCZoomButton alloc] initWithTarget:self 
															  selector:@selector(goSettingSceneCallback:)  
														   textureName: @"title_setting"
														selTextureName: @"title_setting1"
															  textName: @""
															  position: (CGPointMake(ipx(144), ipy(330)))
															 afterTime:0.8f];
		[self addChild: btnSetting];
        
        /*
        CCMenuItemImage *moreApps;
        moreApps = [CCMenuItemImage itemFromNormalImage:SHImageString(@"moreAppsBtn01") selectedImage:SHImageString(@"moreAppsBtn02") target:self selector:@selector(onMoreApps:)];
        
        CCMenu* moreAppsMenu = [CCMenu menuWithItems: moreApps, nil];
        moreAppsMenu.position = ccp(ipx(285), ipy(435));
        
        [self addChild:moreAppsMenu];
        
        CCMenuItemImage *restore;
        restore = [CCMenuItemImage itemFromNormalImage:SHImageString(@"restore") selectedImage:SHImageString(@"restore") target:self selector:@selector(restoreiap:)];
        
        CCMenu* restoreMenu = [CCMenu menuWithItems: restore, nil];
        restoreMenu.position = ccp(ipx(25), ipy(25));
        
        [self addChild:restoreMenu];
        */
	}
	return self;
}

-(void)onMoreApps:(id)sneder
{
    towerGameAppDelegate* del = (towerGameAppDelegate*)[UIApplication sharedApplication].delegate;
    [del showMoreApps];
}

- (void) goBeginSceneCallback: (id) sender
{
	CCScene* beginScene = [BeginScene node];
	[[CCDirector sharedDirector] replaceScene:beginScene];	
}

- (void) goScoreSceneCallback: (id) sender
{
   // [(towerGameAppDelegate*)[[UIApplication sharedApplication] delegate] abrirLDB];
	//CCScene* scoreScene = [ScoreScene node];
	//[[CCDirector sharedDirector] replaceScene:scoreScene];
	
    [[towerGameAppDelegate getInstance] showGCLeaderBoard];
}

- (void) goSettingSceneCallback: (id) sender
{
	CCScene* settingScene = [SettingScene node];
	[[CCDirector sharedDirector] replaceScene:settingScene];	
}

- (void) draw
{
	[backManager draw];
	[backManager drawTitle: 0];
}

- (void) dealloc
{
	[super dealloc];
}

- (void) restoreiap: (id) sender

{
    CCScene* restoreIAPScene = [RestoreIAPScene node];
	[[CCDirector sharedDirector] replaceScene: restoreIAPScene];	
	//[super dealloc];
}

@end

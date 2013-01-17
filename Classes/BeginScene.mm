//
//  BeginScene.mm
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeginScene.h"
#import "TitleScene.h"
#import "QuickGame.h"
#import "CCButton.h"
#import "CCZoomButton.h"
#import "CCZoom1Button.h"
#import "../InApp/MKStoreManager.h"
#import "towerGameAppDelegate.h"

@implementation BeginScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BeginScene *layer = [BeginScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ( mainDelegate.m_showhint == 1 ) {
        mainDelegate.m_showhint =2;
    }
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
        towerGameAppDelegate* del = (towerGameAppDelegate*)[UIApplication sharedApplication].delegate;
        [del chartBoostWillShow:NO];
        
		backManager = [BackgroundManager sharedBackgroundManager];
		resManager = [ResourceManager sharedResourceManager]; 

		CCZoom1Button* btnBack = [[CCZoom1Button alloc] initWithTarget:self 
																 selector:@selector(goTitleSceneCallback:)  
															  textureName: @"backbutton"
														   selTextureName: @"backbutton1"
																 position: (CGPointMake(ipx(5), ipy(420)))
																afterTime:0.4f];
		[self addChild: btnBack];
		
		CCZoomButton* btnQuickGame = [[CCZoomButton alloc] initWithTarget:self 
												selector:@selector(goQuickGameSceneCallback:)  
											   textureName: @"quick_game"
											selTextureName: @"quick_game1"
												 textName: @""
												position: (CGPointMake(ipx(154), ipy(250)))
											   afterTime:0.6f];
		[self addChild: btnQuickGame];
		
		CCZoomButton* btnBuildCity = [[CCZoomButton alloc] initWithTarget:self 
															 selector:@selector(goScoreSceneCallback:)  
														  textureName: @"quick_score"
													   selTextureName: @"quick_score1"
															 textName: @""
															 position: (CGPointMake(ipx(154), ipy(286)))
															afterTime:0.8f];
		[self addChild: btnBuildCity];

		CCZoomButton* btnPartyGame = [[CCZoomButton alloc] initWithTarget:self 
															  selector:@selector(goTimeAttackSceneCallback:)  
														   textureName: @"quick_time"
														selTextureName: @"quick_time1"
															  textName: @""
															  position: (CGPointMake(ipx(154), ipy(320)))
															 afterTime:1.0f];
		[self addChild: btnPartyGame];
		
	}
	return self;
}

- (void) goTitleSceneCallback: (id) sender
{
    
	CCScene* beginScene = [TitleScene node];
	[[CCDirector sharedDirector] replaceScene:beginScene];		
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1)
        {
            [[MKStoreManager sharedManager] buyFeatureA];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1)
        {
            [[MKStoreManager sharedManager] buyFeatureA];
        }
    }
}

- (void) goQuickGameSceneCallback: (id) sender
{
    CCLOG(@"quick game tapped");
    /*if([MKStoreManager featureAPurchased] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"To enable this fuction, you must pay $0.99 via in-app purchase.Do you want to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles: @"Yes", nil];
        alert.tag = 1;
        [alert show];	
        [alert release];        
    }
    else*/
    {
        CCScene* quickScene = [QuickGame node];
        ((QuickGame*)quickScene).m_nGameType = GAMETYPE_QUICK;
        [[CCDirector sharedDirector] replaceScene:quickScene];	
    }
}

- (void) goScoreSceneCallback: (id) sender
{
    
    
    
    
    if(YES==NO)//[MKStoreManager featureAPurchased] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"To enable this fuction, you must pay $0.99 via in-app purchase.Do you want to continue?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles: @"Yes", nil];
        alert.tag = 2;
        [alert show];	
        [alert release];        
    }
    else
    {
        CCScene* quickScene = [QuickGame node];
        ((QuickGame*)quickScene).m_nGameType = GAMETYPE_SCOREATTACK;
        [[CCDirector sharedDirector] replaceScene:quickScene];	
    }
}

- (void) goTimeAttackSceneCallback: (id) sender
{
	CCScene* quickScene = [QuickGame node];
	((QuickGame*)quickScene).m_nGameType = GAMETYPE_TIMEATTACK;
	[[CCDirector sharedDirector] replaceScene:quickScene];	
}

- (void) draw
{
    
	[backManager draw];
	[backManager drawTitle: 30];
    
    
}

@end

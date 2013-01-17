//
//  BeginScene.mm
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReloadScene.h"
#import "TitleScene.h"
#import "QuickGame.h"

#import "towerGameAppDelegate.h"

@implementation ReloadScene
//@synthesize gametype;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ReloadScene *layer = [ReloadScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    //always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
		
	}
	return self;


}
- (void) dealloc
{
	[super dealloc];
}

- (void) draw
{
    
	towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ( mainDelegate.m_showhint == 90 ) {
        mainDelegate.m_showhint = 1;
        CCScene* quickScene = [QuickGame node];
        ((QuickGame*)quickScene).m_nGameType = GAMETYPE_QUICK;
        [[CCDirector sharedDirector] replaceScene:quickScene];	
    }else if ( mainDelegate.m_showhint == 91 ) {
        mainDelegate.m_showhint = 1;
        CCScene* quickScene = [QuickGame node];
        ((QuickGame*)quickScene).m_nGameType = GAMETYPE_SCOREATTACK;
        [[CCDirector sharedDirector] replaceScene:quickScene];	
    }else if ( mainDelegate.m_showhint == 92 ) {
        mainDelegate.m_showhint = 1;
        CCScene* quickScene = [QuickGame node];
        ((QuickGame*)quickScene).m_nGameType = GAMETYPE_TIMEATTACK;
        [[CCDirector sharedDirector] replaceScene:quickScene];	
    }		
    
    
}

@end

//
//  SettingScene.mm
//  towerGame
//
//  Created by KCU on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "TitleScene.h"
#import "towerGameAppDelegate.h"
#import "MKStoreManager.h"
#import "RestoreIAPScene.h"
//#import "TitleScene.h"
//#import "BackgroundManager.h"
//#import "CCSlider.h"
//#import "CC3PartButton.h"
//#import "SoundManager.h"
#import "AppSettings.h"
//#import "ScoreManager.h"
#import "AppSpecificValues.h"

//#define kTagMusicSlider 100
//#//define kTagSFXSlider	101
//#define __CLIPPING_SLIDERBAR   // Use clipping sliderbar
//#define __TOUCH_END_SLIDERBAR  // Use touch end callback sliderbar


@implementation RestoreIAPScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RestoreIAPScene *layer = [RestoreIAPScene node];
	
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
        CCSprite *back = [CCSprite spriteWithFile:SHImageString(@"iappop")];  
        [back setPosition: ccp(ipx(160), ipy(240))];
        [self addChild: back];
        
        CCMenuItemImage *yesButton;
        yesButton = [CCMenuItemImage itemFromNormalImage:SHImageString(@"yes") selectedImage:SHImageString(@"yes") target:self selector:@selector(restoreIAP:)];
        
        CCMenu* yesButtonMenu = [CCMenu menuWithItems: yesButton, nil];
        yesButtonMenu.position = ccp(ipx(100), ipy(165));
        
        [self addChild:yesButtonMenu];
        
        CCMenuItemImage *noButton;
        noButton = [CCMenuItemImage itemFromNormalImage:SHImageString(@"no") selectedImage:SHImageString(@"no") target:self selector:@selector(cancelRestoreIAP:)];
        
        CCMenu* noButtonMenu = [CCMenu menuWithItems: noButton, nil];
        noButtonMenu.position = ccp(ipx(220), ipy(165));
        
        [self addChild:noButtonMenu];
    }
	return self;
}



- (void) restoreIAP: (id) sender
{
    /*
    //Show LeaderBoard
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        
#ifdef FreeApp
        if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO) {
            
            
            
            //mainDelegate.m_no_ads = YES;
            //[self cancelRestoreIAP:sender];
            
            [self cancelRestoreIAP:sender];
            
        }
        else {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Completed" message:@"In app Purchase Remove Ads Restored" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            alert.tag = 1;
            //            [alert show];
            //            [alert release];
            //mainDelegate.m_no_ads = NO;
            
            //towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
            
            mainDelegate.m_no_ads = NO;
            
            // Create ad but don't show it yet
            //[[AdsManager sharedAdsManager] startMobclix]; 
            
            //[[iaAdsManager sharedAdsManager] hideAd];
            
            //viewsInWindow = [[self.view superview] subviews] ;
            //UIView *myEAGLView = [mainDelegate.window.superview.subviews objectAtIndex:0];    // For first and so on for next views.
            //"onehaze_NeonTower_iPhone"
            //[InneractiveAd DisplayAd: @"iOS_Test" withType:(IaAdType_Banner) withRoot:self.us withReload:60 ];
            
            //m_btnMenuAd.visible = FALSE;
            [self cancelRestoreIAP:sender];
        }
#endif
        
        
    } onError:^(NSError *A) {
        NSLog(@"Not iaps to restore");
        [self cancelRestoreIAP:sender];
        
        
    }];

    */
	
}

- (void) cancelRestoreIAP: (id) sender
{
    //[self dealloc];
	CCScene* titleScene = [TitleScene node];
	[[CCDirector sharedDirector] replaceScene:titleScene];	
}

- (void) dealloc
{
	[super dealloc];
}

@end

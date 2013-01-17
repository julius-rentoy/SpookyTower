//
//  towerGameAppDelegate.h
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
//#import "BCFAds.h"

//#import "GameCenterManager.h"
#import "GCViewController.h"
#import "GameUtils.h"
#import <GameKit/GameKit.h>
#import "Global.h"

#import <UIKit/UIKit.h>


#import "Chartboost.h"

#import <RevMobAds/RevMobAds.h>
#import "GameCenterMgr.h"
//#import "QuickGame.h"
@class RootViewController;



@interface towerGameAppDelegate : NSObject <UIApplicationDelegate,GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, RevMobAdsDelegate,ChartboostDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    GCViewController *viewController2;
	
	//GameCenterManager* gameCenterManager;
	NSString* currentLeaderBoard;
    
    int m_popup_iap_count;
    int m_popup_rate_count;
    BOOL m_no_ads;
    BOOL m_rateapp;
    int m_showhint;
    BOOL m_bootup;
 
   
    
    BOOL chartBoostWillShow, revmobWillShow;
    
    
}


@property (nonatomic, retain) UIWindow *window;
//@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic,retain) NSString *strCurrentLeaderBoard;
@property (nonatomic) int m_popup_iap_count;
@property (nonatomic) int m_popup_rate_count;
@property (nonatomic) BOOL m_no_ads;
@property (nonatomic) BOOL m_rateapp;
@property (nonatomic) int m_showhint;
@property (nonatomic) BOOL m_bootup;

+ (towerGameAppDelegate *) getInstance;
- (UIViewController *) getRootViewController;
- (NSString *) getLeaderBoardForGameType:(int)gameType;
- (void) uploadScore:(int)score withGameType:(int)gameType;
- (void) showGCLeaderBoard;

- (void) addOne;
- (void)submitScore;
- (IBAction) showLeaderboard;
- (IBAction) showAchievements;

- (void)abrirLDB;
- (void)abrirACHV;
- (void)clearIAP;
- (void) chartBoostWillShow: (BOOL) b;
- (void) gameOverChartboost;
- (void) gameOverRevmob;
- (void) freeGameChartboost;

@end

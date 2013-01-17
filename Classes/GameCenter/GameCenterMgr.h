//
//  GameCenterMgr.h
//  pitstop
//
//  Created by Ruz on 6/3/11.
//  Copyright 2011 Smartwave Studios. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "GameConfig.h"
typedef enum {
	eGCALeaderboards,
	eGCAAchievements,
	eGCANone
} eGCAction;

typedef enum {
	eGCMKScore = 0,
    eGCMKBonus, //1
    eGCMKStartGame,//2
	eGCMKEndGame,//3
    eGCMKEndSuddenDeath,
    eGCMKRetry,
    eGCMKRetryConfirmed,
    eGCMKRetryDenied,
    eGCMKBackToMain,
    eGCMKForfeit,
    eGCMKInviteGame,
} eGCMessageKey;

//#define kLeaderboardEasy        @"com.moxygames.donutdunk.easy"
//#define kLeaderboardMed         @"com.moxygames.donutdunk.med"
//#define kLeaderboardHard        @"com.moxygames.donutdunk.hard"
//#define kLeaderboardClassicMP   @"com.moxygames.donutdunk.classicMP"
//#define kLeaderboardFeed        @"com.moxygames.donutdunk.feed"
//#define kLeaderboardFeedMP      @"com.moxygames.donutdunk.feedMP"
//#define kLeaderboardFight       @"com.moxygames.donutdunk.fight"
//#define kLeaderboardFightMP     @"com.moxygames.donutdunk.fightMP"







@interface GameCenterMgr : NSObject <GKAchievementViewControllerDelegate,GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate,GKMatchDelegate>{
	NSMutableDictionary *achievementsDictionary;
	NSMutableArray *maScores;
	GKLocalPlayer *localPlayer;
	eGCAction currAction;
	GKMatch *myMatch;
	BOOL matchStarted;
	BOOL userAuthenticated;
	int currTimeScope;
	NSString *gcLeaderboardCategory;
    BOOL bIsPlayerHost;
	
	
@public
    NSMutableArray *aAchievementDesc;
	NSString *otherPlayerName;
	NSString *myPlayerName;
    int nOtherPlayerScore;
	BOOL bIsInGameCenter;
	int nPlayerStat;
    int nPlayerScore;
    BOOL bOpponentIsAskingForRematch;
    BOOL bPlayerIsAskingForRematch;
    BOOL bOpponentForfeited;

}


+ (GameCenterMgr *)sharedInstance;

- (void) setUpGameCenter;

- (void) showAchievements;
- (void) showLeaderboard:(NSString*)category;
- (NSArray *) retrieveAchievmentMetadata;
- (void) uploadScore:(int)newHighScore gameMode:(NSString*)leaderBoard;
- (void) uploadAchievement:(NSString*)achievementID withPercentComplete:(float)percentComplete;

//- (void) hostMatchForPlayerGroup:(eGameModes)mode;;

- (void) sendMessage:(NSString*)msg forKey:(eGCMessageKey)key;
- (void) disconnectFromMatch;


- (void) removeGCView;
- (BOOL) isGameCenterAPIAvailable;
- (void) authenticateLocalPlayer;
- (void) loadPlayerData: (NSArray *) identifiers;
- (void) loadAchievements;
- (void) loadAchievementDescriptions;
- (void) reportAchievementIdentifier:(NSString*) identifier percentComplete: (float) percent;
- (void) reportScore:(int64_t) score forCategory: (NSString*) category;
- (void) presentViewController:(UIViewController*)vc;
- (void) dismissModalViewController;
- (BOOL) isLoggedIn;
- (BOOL) isAchievementLockedFor:(NSString*)achievementID;
- (void) handleInvites;
- (void) resetAchievements;

@end

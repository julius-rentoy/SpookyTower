//
//  GameCenterMgr.m
//  pitstop
//
//  Created by Ruz on 6/3/11.
//  Copyright 2011 Smartwave Studios. All rights reserved.
//

#import "GameCenterMgr.h"
#import "EAGLView.h"
#import "GKAchievementHandler.h"



#import "towerGameAppDelegate.h"
//#import "InGame.h"
//#import "Config.h"
//#import "Loading.h"

#define kGCMinPlayers 2
#define kGCMaxPlayers 2

static GameCenterMgr *instance;

@implementation GameCenterMgr
+ (GameCenterMgr *)sharedInstance 
{
	if (!instance)
		instance = [[self alloc] init];
	
	return instance;
}

- (id) init
{
	if ((self = [super init])) 
	{
		achievementsDictionary = [[NSMutableDictionary dictionary] retain];
		
		currAction = eGCANone;
		
		matchStarted = NO;
		userAuthenticated = NO;
//		currTimeScope = -1;
		nPlayerStat = 0;
		maScores = [[NSMutableArray alloc] init];
		bOpponentIsAskingForRematch = NO;
        bPlayerIsAskingForRematch = NO;
		
		if ([self isGameCenterAPIAvailable])
		{
			NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
			[nc addObserver:self 
				   selector:@selector(authenticationChanged) 
					   name:GKPlayerAuthenticationDidChangeNotificationName 
					 object:nil];
		}	
	}
	return self;
}

- (void) dealloc 
{
	[super dealloc];
	[achievementsDictionary release];
	[maScores release];
	[myMatch release];
	instance = nil;
	[aAchievementDesc release];
	[otherPlayerName release];
    [gcLeaderboardCategory release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setUpGameCenter {
	if ([self isGameCenterAPIAvailable])
		[self authenticateLocalPlayer];
}

- (BOOL) isLoggedIn
{
	BOOL isIn = NO;
	if (localPlayer)
		isIn = YES;
	return isIn;
}

// Check for compatibility w/ Game Center
- (BOOL) isGameCenterAPIAvailable
{
    // Check for presence of GKLocalPlayer class.
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
	
    // The device must be running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (localPlayerClassAvailable && osVersionSupported);
}

// Retreive local player
- (void) authenticateLocalPlayer
{
    localPlayer = [GKLocalPlayer localPlayer];
	NSLog(@"Authenticating local user...");
    if (localPlayer.authenticated == NO) {     
        [localPlayer authenticateWithCompletionHandler:nil];        
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void)authenticationChanged {    
    if (localPlayer.isAuthenticated && !userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated.");
		userAuthenticated = YES;
		[self loadAchievements];
		[self loadAchievementDescriptions];
		//[self handleInvites];
    } else if (!localPlayer.isAuthenticated && userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		userAuthenticated = FALSE;
    }
}

- (void) resetAchievements {
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error == nil)
         {
             NSLog(@"reset!!!!");
         }
     }];

}

- (void) loadPlayerData: (NSArray *) identifiers
{
	NSLog(@"%@",identifiers);
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        else 
        {			
            for (GKPlayer *player in players) {
				if (player.playerID != localPlayer.playerID)
				{
					otherPlayerName = [[NSString stringWithFormat:@"%@", player.alias] retain];
 				}
			}
			myPlayerName = [[NSString stringWithFormat:@"%@", localPlayer.alias] retain];
        }
	}];
}

#pragma mark -
#pragma mark Modal View Methods
#pragma mark -

-(void) presentViewController:(UIViewController*)vc
{
    UIViewController *rootVC    =   [[towerGameAppDelegate getInstance] getRootViewController];
    [rootVC presentModalViewController:vc animated:YES];
}

-(void) dismissModalViewController
{
	
	UIViewController *rootVC    =   [[towerGameAppDelegate getInstance] getRootViewController];
    [rootVC dismissModalViewControllerAnimated:YES];

}


#pragma mark -
#pragma mark Leaderboards
#pragma mark -



- (void) uploadScore:(int)newHighScore gameMode:(NSString*)leaderBoard
{
	[self reportScore:newHighScore forCategory:leaderBoard];
}

// Send new high score to server
- (void) reportScore:(int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
            NSLog(@"ERROR");
            // SAVE SCORE
        }
		else {
            NSLog(@"SCORE REPORTED: %d",(int)scoreReporter.value);
		}

    }];
}

// Deploy default game center view for leaderboards
- (void) showLeaderboard:(NSString*)category;
{
	if ([self isLoggedIn])
	{
		GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
        gcLeaderboardCategory = [category copy];
        leaderboardController.category = category;
        
		if (leaderboardController != nil)
		{
			leaderboardController.leaderboardDelegate = self;
			[self presentViewController:leaderboardController];
		}
	}
	else {
		currAction = eGCALeaderboards;
		[self setUpGameCenter];
	}

    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewController];
}


- (NSArray *) retrieveAchievmentMetadata
{
   __block  NSArray *ret = nil;
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
     ^(NSArray *descriptions, NSError *error) {
         if (error != nil)
             // process the errors
             if (descriptions != nil)
             {
                 ret = [NSArray arrayWithArray:descriptions];
                 CCLOG(@"has desriptions : %d",ret.count);
             }
                 // use the achievement descriptions.
                 }];
    return ret;

}

#pragma mark -
#pragma mark Achievements
#pragma mark -

- (void) uploadAchievement:(NSString*)achievementID withPercentComplete:(float)percentComplete
{
	
	if ([self isAchievementLockedFor:achievementID])
		[self reportAchievementIdentifier:achievementID percentComplete:percentComplete];

}

- (void) reportAchievementIdentifier:(NSString*) identifier percentComplete: (float) percent
{
//	if (![self isAchievementLockedFor:identifier]) {
//		return;
//	}
	
    CCLOG(@"reportAchievementIdentifier %@",identifier);
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
	if (percent > 100.0) {
		percent = 100.0;
	}
    if (achievement)
    {
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error)
		 {
			 if (error != nil)
			 {
                 NSLog(@"ERROR");
                 // SAVE ACHIEVEMENT
			 }
			 else 
			 {
				 [self loadAchievements];
				 
				
				 for (GKAchievementDescription *desc in aAchievementDesc) {
					 if ([desc.identifier isEqualToString:achievement.identifier] && percent == 100.0) {
                         NSLog(@"ACHIEVEMENT REPORTED: %@",(int)achievement.identifier);
                        

					 }
					  
				 }
				
			 }

		 }];
    }
}

// Deploy default game center view for achievements
- (void) showAchievements
{
	if ([self isLoggedIn])
	{
		GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
		if (achievements != nil)
		{
			
			achievements.achievementDelegate = self;
			[self presentViewController:achievements];
			
		}
		[achievements release];
    }
	else
	{
		currAction = eGCAAchievements;
		[self setUpGameCenter];
	}

}

- (void) loadAchievements
{    
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
		if (error != nil)
		{
			// handle errors
		}
		else
		{
			switch (currAction) {
				case eGCALeaderboards:
					[self showLeaderboard:gcLeaderboardCategory];
					currAction = eGCANone;
					break;
				case eGCAAchievements:
					[self showAchievements];
					currAction = eGCANone;
					break;
				case eGCANone:
					break;
				default:
					break;
			}
		}

		if (achievements != nil)
		{
			
			[achievementsDictionary removeAllObjects];
			
			for (GKAchievement* achievement in achievements)
				if ([achievement isCompleted]) {
					[achievementsDictionary setObject:achievement forKey:achievement.identifier];
					
				}
			
//			[self loadAchievementDescriptions];
		}
	}];
}

- (void) loadAchievementDescriptions
{
	 
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
	 ^(NSArray *descriptions, NSError *error) {
		 if (error != nil)
			 // process the errors
			 NSLog(@"ERROR");
			 if (descriptions != nil)
				 aAchievementDesc = [[NSMutableArray arrayWithArray:descriptions]retain];
				 // use the achievement descriptions.
		 
		 NSLog(@"aAchievementDesc: %@",aAchievementDesc);
	 }];
}

- (BOOL) isAchievementLockedFor:(NSString*)achievementID 
{
//    CCLOG(@"isAchievementLockedFor %@",achievementsDictionary);
	BOOL isLocked = YES;
	for (NSString *key in [achievementsDictionary allKeys])
	{
		if ([achievementID isEqualToString:key]) {
			isLocked = NO;
		}
	}
	
	return isLocked;
}



#pragma mark -
#pragma mark GKAchievementViewControllerDelegate Method
#pragma mark -
- (void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [self dismissModalViewController];
}





#pragma mark -
#pragma mark Matchmaking
#pragma mark -
/*
- (void) hostMatchForPlayerGroup:(eGameModes)mode;
{
	if ([self isGameCenterAPIAvailable])
	{
        bIsPlayerHost = YES;
		GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
		request.minPlayers = kGCMinPlayers;
		request.maxPlayers = kGCMaxPlayers;
        request.playerGroup = mode;
        CCLOG(@"host match for: %d",request.playerGroup);
		
		GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
		mmvc.matchmakerDelegate = self;
		
		[self presentViewController:mmvc];
	}
   
}


- (void) handleInvites
{
	[GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
		// Insert application-specific code here to clean up any games in progress.
		if (acceptedInvite)
		{
            bIsPlayerHost = NO;
			GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite] autorelease];
			mmvc.matchmakerDelegate = self;
			[self presentViewController:mmvc];
		}
		else if (playersToInvite)
		{
            bIsPlayerHost = YES;
			GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
			request.minPlayers = kGCMinPlayers;
			request.maxPlayers = kGCMaxPlayers;
			request.playersToInvite = playersToInvite;
            Config *conf = [Config sharedConfig];
            request.playerGroup = conf->_currentGameMode;
            CCLOG(@"made invite for: %d",request.playerGroup);
			
			GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
			mmvc.matchmakerDelegate = self;
			[self presentViewController:mmvc];
		}
	};
}
 */
 
- (void) disconnectFromMatch

{
	bIsInGameCenter = NO;
	[myMatch disconnect];
	myMatch = nil;
    nOtherPlayerScore = 0;
    otherPlayerName = nil;
    matchStarted = NO;
    bOpponentIsAskingForRematch = NO;
    bPlayerIsAskingForRematch = NO;
}

#pragma mark -
#pragma mark GKMatchmakerViewControllerDelegate Methods
#pragma mark -

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissModalViewController];
    // implement any specific code in your application here.
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissModalViewController];
    // Display the error to the user.
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
	
    
    
    matchStarted = NO;
    myMatch = match;
	[myMatch retain];
    match.delegate = self;
    
    otherPlayerName = nil;
    nOtherPlayerScore = 0;
    nPlayerScore = 0;
    bOpponentForfeited = NO;

		
    if (!matchStarted && match.expectedPlayerCount == 0)
    {
        
//        Config *conf = [Config sharedConfig];
//        conf->_nextSceneType = eGameSceneIngame;
//        CCLOG(@"invite accepted for game: %d",viewController.matchRequest.playerGroup);
//        conf->_currentGameMode = (eGameModes)viewController.matchRequest.playerGroup;
//        conf->_currentGameDifficulty = eGameDifficultyEasy;

		[self loadPlayerData:myMatch.playerIDs];
		matchStarted = YES;
		[self dismissModalViewController];
		bIsInGameCenter = YES;
        
        
        
        
//        if (bIsPlayerHost) {
//            Config *conf = [Config sharedConfig];
//            [self sendMessage:[NSString stringWithFormat:@"%d",conf->_currentGameMode] forKey:eGCMKInviteGame];
//            [[CCDirector sharedDirector] replaceScene:[Loading scene]];
//        }
        

    }
	
	
}

-(void)removeGCView
{
	[self dismissModalViewController];	
}

#pragma mark -
#pragma mark GKMatchDelegate Method
#pragma mark -

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    CCLOG(@"match %@ didChangeState:%d",playerID,state);
    switch (state)
    {
        case GKPlayerStateConnected: {
            
			NSLog(@"Player connected! %@",match.playerIDs);
			if (!matchStarted && match.expectedPlayerCount == 0)
			{
                otherPlayerName = nil;
                nOtherPlayerScore = 0;
                nPlayerScore = 0;
                bOpponentIsAskingForRematch = NO;
                bOpponentForfeited = NO;
				[self loadPlayerData:myMatch.playerIDs];
				matchStarted = YES;
				[self dismissModalViewController];
				bIsInGameCenter = YES;

                                
//                Config *conf = [Config sharedConfig];
//                conf->_nextSceneType = eGameSceneIngame;
//                conf->_currentGameMode = eGameModeMultiplayerFeed;
//                conf->_currentGameDifficulty = eGameDifficultyEasy;
                
               // [[CCDirector sharedDirector] replaceScene:[Loading scene]];
			}
			break;
        }
        
        case GKPlayerStateDisconnected: {
            if (playerID != localPlayer.playerID && myMatch!= nil) {
                NSLog(@"Other Player disconnected!");
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rematchDenied) object:nil];
                [self disconnectFromMatch];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rematchDenied) object:nil];
                //[[InGame instance] endGameCenterSession];

            }
            else {
                NSLog(@"Player disconnected!");
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rematchDenied) object:nil];
//                [[InGame instance] endGameCenterSession];

            }
			break;
        }
        default:
            break;
    }
		
    
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (myMatch != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
//    [[InGame instance] endGameCenterSession];
    [self disconnectFromMatch];
}

// The match was unable to be established with any players due to an error.
- (void) match:(GKMatch *)match didFailWithError:(NSError *)error
{
	if (myMatch != match) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
//    [[InGame instance] endGameCenterSession];
    [self disconnectFromMatch];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSDictionary *receivedMsg = [[unarchiver decodeObjectForKey:@"message"] retain];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// message is from other player
	if (![playerID isEqualToString:localPlayer.playerID])
	{
		NSLog(@"RECEIVED PACKET: %@",receivedMsg);
        
        id key = [[receivedMsg allKeys] objectAtIndex:0];
		
        id val = [receivedMsg objectForKey:key];

        switch ([key intValue]) {
            case eGCMKStartGame:
                NSLog(@"Opponent restart game");

               // [[InGame instance] restartGame];
                break;
            case eGCMKEndSuddenDeath:
                bOpponentIsAskingForRematch = NO;
             //   [[InGame instance] endSuddenDeathGame];
                break;
            case eGCMKEndGame:
                NSLog(@"Opponent finished game");
                bOpponentIsAskingForRematch = NO;
             //   [[InGame instance] endGame];
                break;
            case eGCMKRetry: 
            {
                NSLog(@"Opponent is asking for a rematch");

                bOpponentIsAskingForRematch = YES;
                
                if (bPlayerIsAskingForRematch)
                {
                    NSLog(@"Player waiting for rematch and opponent accepted");
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rematchDenied) object:nil];
                   // [[InGame instance] restartGame];
                }
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call for rematch" message:[NSString stringWithFormat:@"%@ wants revenge!",otherPlayerName] delegate:self cancelButtonTitle:@"I'm afraid" otherButtonTitles:@"You're on!", nil];
//                [alert show];
//                [alert release];
            }
                break;
            case eGCMKRetryConfirmed:
//                [[InGame instance] restartGame];
                break;
            case eGCMKRetryDenied:
//                [[InGame instance] endGameCenterSession];
                break;
            case eGCMKBackToMain:
            {
                bOpponentIsAskingForRematch = YES; // do not allow rematch selector to execute
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:[NSString stringWithFormat:@"Your opponent left the game.",otherPlayerName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [self disconnectFromMatch];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rematchDenied) object:nil];
              //  [[InGame instance] endGameCenterSession];

//                [[InGame instance] endGameCenterSession];
            }
                break;
            case eGCMKScore:
                nOtherPlayerScore = [val intValue];
              // [[InGame instance] opponentScore:nOtherPlayerScore];
                break;
            case eGCMKBonus:
//                nOtherPlayerScore = [val intValue];
//                [[InGame instance] opponentBonus:nOtherPlayerScore];;
                break;
            case eGCMKForfeit:
            {
                bOpponentForfeited = YES;
                bOpponentIsAskingForRematch = NO;
               // [[InGame instance] endGame];
            }
                break;
            case eGCMKInviteGame:
            {
//                Config *conf = [Config sharedConfig];
//                conf->_nextSceneType = eGameSceneIngame;
//                conf->_currentGameMode = (eGameModes)[val intValue];
//                conf->_currentGameDifficulty = eGameDifficultyEasy;
//                
//                [[CCDirector sharedDirector] replaceScene:[Loading scene]];

            }
                break;
            default:
                break;
        }
		
	}
	[receivedMsg release];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
//    if (buttonIndex == 0) {
//        [[InGame instance] endGameCenterSession];
//        [self sendMessage:@"" forKey:eGCMKRetryDenied];
//    }
//    else
//    {
//        [self sendMessage:@"" forKey:eGCMKStartGame];
//        [[InGame instance] restartGame];
//    }
}
#pragma mark -
#pragma mark Send Message 
#pragma mark -

- (void) sendMessage:(NSString*)msg forKey:(eGCMessageKey)key;
{
	
	//TODO: Send score
	NSDictionary *mesg = [NSDictionary dictionaryWithObjectsAndKeys:
						 msg,[NSNumber numberWithInt:key],nil];
	
    if (key == eGCMKRetry)
    {
        if (bOpponentIsAskingForRematch) {
            NSLog(@"player accepted opponent's rematch");
           //[[InGame instance] restartGame];
        }
        else{
            NSLog(@"Player is asking for rematch");
            bPlayerIsAskingForRematch = YES;
            [self performSelector:@selector(rematchDenied) withObject:nil afterDelay:30];
        }
        
    }
    
    if (key == eGCMKForfeit && myMatch) {
        //[[InGame instance] endGameCenterSession];
    }
	
	NSLog(@"SEND PACKET: %@",mesg);
	NSMutableData *packet = [[NSMutableData alloc] init];
	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:packet];
	[archiver encodeObject:mesg forKey:@"message"];
	[archiver finishEncoding];
	[archiver release];
	
    
	[myMatch sendDataToAllPlayers:packet withDataMode:GKMatchSendDataReliable error:nil];
	
	[packet release];
    
}

- (void) rematchDenied {
    if (!bOpponentIsAskingForRematch) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rematch Denied" message:[NSString stringWithFormat:@"Your opponent left the game.",otherPlayerName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
//        [[InGame instance] endGameCenterSession];
        [self disconnectFromMatch];

    }
}



@end

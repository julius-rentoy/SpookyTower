//
//  towerGameAppDelegate.m
//  towerGame
//
//  Created by KCU on 6/13/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import "MKStoreManager.h"
#import "cocos2d.h"


#import "Chartboost.h"
#import "towerGameAppDelegate.h"
#import "GameConfig.h"
#import "LoadScene.h"
#import "RootViewController.h"

#import "AppSpecificValues.h"
#import "iaAdsManager.h"
//#import "InneractiveAd.h"

#import "FlurryAnalytics.h"
#import "TapjoyConnect.h"  
#import "TitleScene.h"
//#import "QuickGame.h"

#define kCBInterstitialGameOver   @"Gameover (Spooky)"
#define kCBInterstitialGameOverBanner   @"Gameover Banner (Spooky)"
#define kCBInterstitialAppLaunched @"Application Launched (Spooky)"

#import "GameCenterMgr.h"
@implementation towerGameAppDelegate

@synthesize window;
//@synthesize gameCenterManager, currentLeaderBoard;
@synthesize strCurrentLeaderBoard;
@synthesize m_no_ads;
@synthesize m_rateapp;
@synthesize m_popup_iap_count;
@synthesize m_popup_rate_count;
@synthesize m_showhint;
@synthesize m_bootup;

static towerGameAppDelegate *instance = NULL;

+ (towerGameAppDelegate *) getInstance
{
    return instance;
}

- (UIViewController *) getRootViewController
{
    return viewController;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    instance    =   self;
    
    [RevMobAds startSessionWithAppID:kRevMobID];
    [RevMobAds loadFullscreenAd];
    [RevMobAds showFullscreenAd];
    m_bootup = 1;
    m_showhint = 1; // show hand hint on bootload level 1 only
#ifdef FreeApp
    [[iaAdsManager sharedAdsManager] startMobclix];
    //[InneractiveAd DisplayAd: @"onehaze_NeonTower_iPhone" withType:(IaAdType_Banner) withRoot:viewController.view withReload:60 ];
    m_popup_iap_count = 0;
    m_no_ads = NO;
    m_popup_rate_count = 0;
    m_rateapp = YES;
#endif
    
#ifdef PaidApp
    m_popup_iap_count = 0;
    m_no_ads = NO;
    m_popup_rate_count = 0;
    m_rateapp = YES;
    
#endif
    [MKStoreManager sharedManager];
    g_GameUtils = [[GameUtils alloc] init];
	[g_GameUtils InitGameInfo];

	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// To enable Hi-Red mode (iPhone4)
	//	[director setContentScaleFactor:2];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        //[director enableRetinaDisplay:YES];
        // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
        if( ! [director enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
	}
    
	
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
//#else
//	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
    [window setRootViewController:viewController];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    [FlurryAnalytics startSession:kFlurryID];
    
    [TapjoyConnect requestTapjoyConnect:kTapJoyConnectID secretKey:kTapJoyConnectSecretKey];
	

    
    chartBoostWillShow = true;
    
   
    
    
    
    viewController2 =   [[GCViewController alloc] init];
    [[GameCenterMgr sharedInstance] setUpGameCenter];
    self.strCurrentLeaderBoard   =   kLeaderBoardQuickGame;
    
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [LoadScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    chartBoostWillShow = true;
    

    
    [self initiliazeChartboost];
    [self showRevMobAds];
    
//    [RevMobAds showFullscreenAdWithAppID:kRevMobID withDelegate:self];
    
    
    
	[[CCDirector sharedDirector] resume];
    
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //Call bcfads
    //[BCFAds showPopupWithAppID:BCFAdsAppID withDelegate:self];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [self scheduleAlarm];
    
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
    [viewController release];
	[window release];
    [director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[ResourceManager releaseResourceManager];
	[window release];
    [self.strCurrentLeaderBoard release];
	[super dealloc];
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial{
    NSLog(@"Failed to load ad charboost");
}

//////////////////////
//Local Notifications
//////////////////////

- (NSTimeInterval) convertDayToSeconds:(float)day
{
    return 60.0f*60.0f*24.0f*day;
}

-(void) scheduleAlarm 
{
	//LOCAL NOTIFICATIONS
    
    //Cancel all previous Local Notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //Set new Local Notifications
    Class cls = NSClassFromString(@"UILocalNotification");
    
    if (cls != nil) 
    {
        CCLOG(@"schedulet notifs!!");
        UILocalNotification *notif = [[cls alloc] init];
        
        //3 days
        notif.fireDate = [NSDate dateWithTimeInterval:[self convertDayToSeconds:3]
                                            sinceDate:[NSDate date]];
        //notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:60.0f*60.0f*24.0f*3.0f];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"In the mood for some spooky fun? Come back and play Spooky Tower!";
        notif.alertAction = @"PLAY";
        notif.soundName = @"button.wav";
       
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        //NSLog(@"==Local Notification: %@", notif);
        //[notif release];
        
        //7 days
        notif.fireDate = [NSDate dateWithTimeInterval:[self convertDayToSeconds:7] sinceDate:[NSDate date]];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"Dracula, the Mummy, & Frankenstein are waiting for you. Come back and play Spooky Tower!";
        notif.alertAction = @"PLAY";
        notif.soundName = @"button.wav";
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        //NSLog(@"==Local Notification: %@", notif);
        //[notif release];
        
        //15 days
        notif.fireDate = [NSDate dateWithTimeInterval:[self convertDayToSeconds:15] sinceDate:[NSDate date]];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"OMG! Come check out our FREE Game Of The Day!";
        notif.alertAction = @"PLAY";
        notif.soundName = @"button.wav";
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        //NSLog(@"==Local Notification: %@", notif);
        //[notif release];
        
        //30 days
        notif.fireDate = [NSDate dateWithTimeInterval:[self convertDayToSeconds:30] sinceDate:[NSDate date]];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"Halloween is long gone, but it’s always a great time to play Spooky Tower!";
        notif.alertAction = @"PLAY";
        notif.soundName = @"button.wav";
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        //NSLog(@"==Local Notification: %@", notif);
        //[notif release];
        
        //60 days
        notif.fireDate = [NSDate dateWithTimeInterval:[self convertDayToSeconds:60] sinceDate:[NSDate date]];
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = @"FREE GAME ALERT! Come check out our FREE Game Of The Day!";
        notif.alertAction = @"PLAY";
        notif.soundName = @"button.wav";
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        //NSLog(@"==Local Notification: %@", notif);
        //[notif release];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif
{
    // Handle the notificaton when the app is running
   
    CCLOG(@"received notifs : %@",notif.alertBody);
	application.applicationIconBadgeNumber = 0;
    
    
    
    
//    UIAlertView *alert  =   [[[UIAlertView alloc] initWithTitle:@"Notification"
//                                                       message:notif.alertBody
//                                                      delegate:nil
//                                             cancelButtonTitle:nil
//                                              otherButtonTitles:notif.alertAction, nil] autorelease];
//    
//    UIImageView *imageView  =   [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 45, 45)];
//    imageView.image =   [UIImage imageNamed:@"Icon-114.png"];
//    imageView.layer.cornerRadius    =   5.0f;
//    
//    [alert addSubview:imageView];
//    [alert show];
}




/////////////////////////
//END LOCAL NOTIFICATIONS
/////////////////////////


//chartbost methids
// Called when an interstitial has been received, before it is presented on screen
// Return NO if showing an interstitial is currently inappropriate, for example if the user has entered the main game mode.
- (BOOL)shouldDisplayInterstitial:(UIView *)interstitialView
{
    /*
    #ifdef PaidApp
        if (m_bootup == 1 || m_showhint == 1) {
            m_bootup = 0;
            return TRUE;
        }else{
            return false;
        }
    #endif
    */
    
    return chartBoostWillShow;
}
// Called before requesting an interstitial from the back-end
// Only useful to prevent an ad from being implicitly displayed on fast app switching
- (BOOL)shouldRequestInterstitial{
    return TRUE;
}

#pragma mark GameCenter View Controllers

- (void) showMoreApps
{
    
    // Show an showMoreApps
    //if (m_showhint == 1) {
    
    [[Chartboost sharedChartboost] showMoreApps];
    [[Chartboost sharedChartboost] cacheMoreApps];
    //}
    
}



//GAMECENTER


//#pragma mark Action Methods
- (void) initGameCenter {
	if (viewController2 != nil)
		return;
	viewController2 = [GCViewController alloc];
	self.currentLeaderBoard = kEasyLeaderboardID;
//	if ([GameCenterManager isGameCenterAvailable])
//	{
//		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
//		[self.gameCenterManager setDelegate:self];
//		[self.gameCenterManager authenticateLocalUser];
//	}
}

- (void) addOne
{
    /*
    [self initGameCenter];
	NSString* identifier= NULL;
	double percentComplete= 0;
	if (m_nScore==10) {
		identifier= kAchievement100;
		percentComplete= 3000.0;
	}
	else if (m_nScore==40) {
		identifier= kAchievement300;
		percentComplete= 6000.0;
	}
	else if (m_nScore==80) {
		identifier= kAchievement600;
		percentComplete= 9000.0;
	}
	else if (m_nScore==100) {
		identifier= kAchievement1000;
		percentComplete= 12000.0;
	}
	if(identifier!= NULL){
		[self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
	}
	[self performSelector:@selector(submitScore) withObject:nil afterDelay:0.2];
    */
}

- (void) submitScore:(int)score
{
    
}

- (void)submitScore{
	if(m_nScore>0){
		//[self.gameCenterManager reportScore: m_nScore forCategory: self.currentLeaderBoard];
	}
}

#pragma mark GameCenter View Controllers

- (void) abrirLDB{
//	if([GameCenterManager isGameCenterAvailable])
//	{
//		[self initGameCenter];
//		[viewController2.view setHidden:YES];
//		[self.window addSubview:viewController2.view];
//		[self showLeaderboard];
//	}
//	else
//	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Gamecenter is not available in your iOS version" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//	}
	
}

- (void)clearIAP {
	[[MKStoreManager sharedManager] removeAllKeychainData ];
}

- (void) abrirACHV {
//	if([GameCenterManager isGameCenterAvailable])
//	{
//		[self initGameCenter];
//		[viewController2.view setHidden:YES];
//		//[self.window addSubview:gcviewController.view];
//		[self showAchievements];
//	}
//	else
//	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Gamecenter is not available in your iOS version" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//	}
}

- (void) showLeaderboard {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) {
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[viewController2 presentModalViewController: leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)controller{
	[controller dismissModalViewControllerAnimated:YES];
	//	[gcviewController.view removeFromSuperview];
	//	[gcviewController.view setHidden:YES];
}

- (void) showAchievements {
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL){
		achievements.achievementDelegate = self;
		[viewController2 presentModalViewController: achievements animated: YES];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)controller;{
	[controller dismissModalViewControllerAnimated: YES];
	//	[gcviewController.view removeFromSuperview];
	//	[gcviewController.view setHidden:YES];
}

- (IBAction) resetAchievements:(id) sender
{
	//[gameCenterManager resetAchievements];
}

//Bcfads

- (void)popupDidReceive{

    
}
// Called when a popup is available

- (void) chartBoostWillShow: (BOOL) b
{
    chartBoostWillShow = b;
}

- (void) gameOverChartboost
{
    chartBoostWillShow = YES;
    
    [self showChartboostInterstitial:kCBInterstitialGameOver];
    
}

- (void) gameOverRevmob
{
    [self showRevMobAds];
}

- (void)revmobAdDidFailWithError:(NSError *)error
{
    CCLOG(@"%@",error);
}

- (void) freeGameChartboost
{
    chartBoostWillShow = YES;
    
    [self showChartboostInterstitial:kCBInterstitialGameOverBanner];

}

#pragma mark -
#pragma mark - ADS

- (void) showRevMobAds
{
    
    CCLOG(@"********showing revmob ads");
    [RevMobAds showFullscreenAdWithDelegate:self];
    [RevMobAds loadFullscreenAd];
}

- (void) showChartboostInterstitial:(NSString *)cbInterstitial
{
    CCLOG(@"********showing cb");
    Chartboost *chartboost  =   [Chartboost sharedChartboost];
    [chartboost showInterstitial];
   // [chartboost showInterstitial:cbInterstitial];
    //[chartboost cacheInterstitial:cbInterstitial];
}

- (void) initiliazeChartboost
{
    Chartboost *chartboost =     [Chartboost sharedChartboost];
    chartboost.delegate = self;
    chartboost.appId = kChartboostID;
    chartboost.appSignature = kChartboostSignature;
    [chartboost startSession];
    
    [self cachedCBInterstitial];
    
    [self showChartboostInterstitial:kCBInterstitialAppLaunched];
    
 
}

- (void) cachedCBInterstitial
{
    Chartboost *chartboost =     [Chartboost sharedChartboost];
    [chartboost cacheInterstitial:kCBInterstitialGameOver];
    [chartboost cacheInterstitial:kCBInterstitialGameOverBanner];
    [chartboost cacheInterstitial:kCBInterstitialAppLaunched];
    CCLOG(@"*****caching interstitial");
}

- (void) didCacheInterstitial:(NSString *)location
{
    CCLOG(@"*****cached interstitial at locaiton : %@",location);
}

- (void) didFailToLoadInterstitial:(NSString *)location
{
    CCLOG(@"*****failed interstitial at locaiton : %@",location);
}

#pragma mark -
#pragma mark - NEW GAME CENTER LOGIC

- (void) showGCLeaderBoard
{
    CCLOG(@"showing score... : %@",self.strCurrentLeaderBoard);
    
    if ([[GameCenterMgr sharedInstance] isGameCenterAPIAvailable]) {
        [[GameCenterMgr sharedInstance] showLeaderboard:self.strCurrentLeaderBoard];
    }
    else
    {
        UIAlertView *alert  =   [[[UIAlertView alloc] initWithTitle:@"Notice"
                                                           message:@"Gamecenter is not available in your iOS version"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    
}

- (NSString *) getLeaderBoardForGameType:(int)gameType
{
    NSArray *gameLeaderBoards   =   [NSArray arrayWithObjects:
                                     kLeaderBoardQuickGame,
                                     kLeaderBoardScoreAttack,
                                     kLeaderBoardTimeAttack, nil];
    return [gameLeaderBoards objectAtIndex:gameType];
}

- (void) uploadScore:(int)score withGameType:(int)gameType
{
    CCLOG(@"uploading score..");
    NSString *leaderBoardName   =   [self getLeaderBoardForGameType:gameType];
    self.strCurrentLeaderBoard   =   leaderBoardName;
    [[GameCenterMgr sharedInstance] reportScore:score forCategory:leaderBoardName];
}

@end

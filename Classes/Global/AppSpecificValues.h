


#define FreeApp @"FREE"
//#define PaidApp @"PAID"
//#define AppTestFlag @"TEST"

#ifdef PaidApp
// For Free App
#define ChartBoostAppID @"50786dec16ba47226200002c"
#define ChartBoostAppSignature @"bd442cb8267505f9fe3e5b25f85a6221acb418c8"

#define FlurryAnalyticsAppID @"7ZMQTQDWB8D938B2B9J8"

#define TapjoyConnectAppID @"8247dd61-4bc7-4c5e-90f6-f5e5b486ec97"
#define TapjoyConnectSecretKey @"WUZeqzY5LoqkhdYANQ5J"

#define RevMobAdsAppID @"50786daa8f808608000000c1"

#define rateURL @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=567690609&onlyLatestVersion=false&type=Purple+Software"

#define kEasyLeaderboardID @"com.topfreegamesfactory.spookytowerfree.highscore"

#define bannerWillShow 1
//#define revmobWillShow 0
#endif

#ifdef FreeApp
//For Paid App
#define ChartBoostAppID @"50786cbd17ba474537000016"
#define ChartBoostAppSignature @"fcf7a5e1d204cc29c4cb4e5713e0579c4911ab51"

#define FlurryAnalyticsAppID @"XV4BJR3SMVHTD8KPCP6P"

#define TapjoyConnectAppID @"e3a881c8-e4df-414a-b7c4-3c55534bd0b1"
#define TapjoyConnectSecretKey @"tXEwMAM5T4NzbtXS2JXb"

#define RevMobAdsAppID @"50786f0925fe780c00000126"

#define rateURL @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=567688858&onlyLatestVersion=false&type=Purple+Software"

#define kEasyLeaderboardID @"com.topfreegamesfactory.spookytower.highscore"

#define bannerWillShow 0
//#define revmobWillShow 1
#endif



/*
 *  Tiny Wings Remake
 *  http://github.com/haqu/tiny-wings
 *
 *  Created by Sergey Tikhonov http://haqu.net
 *  Released under the MIT License
 *
 */

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H


#define kTouchMultiplier    1//CC_CONTENT_SCALE_FACTOR()
#define kBundleID    [[NSBundle mainBundle] bundleIdentifier]
#define kIsPaidVersion  [kBundleID isEqualToString:@"com.asiaappfund.spookytowerhalloweenpaid"]
#define mergeWithBundle(name)   [NSString stringWithFormat:@"%@.%@",kBundleID,name]
#define kLeaderBoardQuickGame   mergeWithBundle(@"quickgame")
#define kLeaderBoardScoreAttack mergeWithBundle(@"scoreattack")
#define kLeaderBoardTimeAttack  mergeWithBundle(@"timeattack")

#define kIsDeviceIPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kChartboostID           kIsPaidVersion ? @"50786dec16ba47226200002c"    :   @"50786cbd17ba474537000016"
#define kChartboostSignature    kIsPaidVersion ? @"bd442cb8267505f9fe3e5b25f85a6221acb418c8"    :   @"fcf7a5e1d204cc29c4cb4e5713e0579c4911ab51"
#define kRevMobID               kIsPaidVersion ? @"50786daa8f808608000000c1"    :   @"50786f0925fe780c00000126"
#define kFlurryID               kIsPaidVersion ? @"7ZMQTQDWB8D938B2B9J8"    :   @"XV4BJR3SMVHTD8KPCP6P"
#define kTapJoyConnectID        kIsPaidVersion ? @"8247dd61-4bc7-4c5e-90f6-f5e5b486ec97"    :   @"e3a881c8-e4df-414a-b7c4-3c55534bd0b1"
#define kTapJoyConnectSecretKey kIsPaidVersion ? @"WUZeqzY5LoqkhdYANQ5J"    :   @"tXEwMAM5T4NzbtXS2JXb"

#define kRateAppID  kIsPaidVersion ? @"594096919" : @"594096919"

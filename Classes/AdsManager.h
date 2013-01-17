//
//  AdsManager.h
//  Bottle Tunes
//
//  Created by Jason Pawlak on 9/2/11.
//  Copyright 2011 Paw Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MobclixAds.h"

@interface AdsManager : CCLayer {
    MobclixAdView *adView;
    BOOL adStarted;
}

-(UIViewController*) getRootViewController;
-(void) presentViewController:(UIViewController*)vc;
-(void) newAd:(CGPoint)loc;
-(void) showAd;
-(void) hideAd;
-(void) cancelAd;
-(void) startMobclix;
-(NSString*) platform;

+(AdsManager*)sharedAdsManager;

@property (retain, nonatomic) MobclixAdView *adView;
@property (assign, nonatomic) BOOL adStarted;

@end
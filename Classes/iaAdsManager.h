//
//  AdsManager.h
//  Bottle Tunes
//
//  Created by Jason Pawlak on 9/2/11.
//  Copyright 2011 Paw Apps LLC. All rights reserved.
//
//#import "towerGameAppDelegate.h"
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "cocos2d.h"
//#import "InneractiveAd.h"

@interface iaAdsManager : CCLayer {
    UIView *adView;
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

+(iaAdsManager*)sharedAdsManager;

@property (retain, nonatomic) UIView  *adView;
@property (assign, nonatomic) BOOL adStarted;

@end